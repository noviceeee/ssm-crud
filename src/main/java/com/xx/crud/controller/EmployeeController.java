package com.xx.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.xx.crud.bean.Employee;
import com.xx.crud.bean.Msg;
import com.xx.crud.service.EmployeeService;

/**
 * 处理员工CRUD请求
 * @author lazy
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单个、批量删除二合一
	 * 对于{id}:
	 * 单个：1
	 * 批量：1-2-3
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("ids") String ids) {
		if(ids.contains("-")) {//批量删除
			String[] ids_str = ids.split("-");
			List<Integer> del_ids = new ArrayList<>();
			//组装id的集合
			for(String str:ids_str) {
				del_ids.add(Integer.parseInt(str));
			}
			employeeService.deleteBatch(del_ids);
		}else {//单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Msg.success();
	}
	
	/**
	 * 如果直接发送Ajax=PUT形式的请求
	 * 封装的数据
	 * Employee [empId=3, empName=null, gender=null, email=null, dId=null, department=null]
	 * 
	 * 问题：
	 * 请求体中有数据，但是Employee对象封装不上
	 * update emp where emp_id=3;
	 * 
	 * 原因：
	 * Tomcat将请求体中的数据封装成一个map
	 * request.getParameter("XX")就会从这个map中取值
	 * SpringMVC封装POJO对象时，会调用request.getParameter()拿到POJO对象中每个属性的值
	 * PUT请求，请求体中的数据request.getParameter()拿不到
	 * 因为Tomcat不会将PUT请求的请求体中数据封装成map，只有POST请求才封装
	 * 
	 * 解决方案：
	 * 我们要能支持发送PUT之类的请求还要封装请求体中的数据
	 * 1.配置上HttpPutFormContentFilter
	 * 它的作用：将请求体中的数据包装成一个map
	 * request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	 * 
	 * 员工更新
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee) {
		System.out.println(employee);
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	/**
	 * 根据id查询员工信息
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	/**
	 * 检查用户名是否可用
	 * @param empName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName")String empName) {
		//先判断用户名是否是合法表达式
		String regex = "(^[a-zA-Z]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if(!empName.matches(regex)) {
			return Msg.fail().add("validate_msg", "名字应为3-16位的英文或2-5位的中文");
		}
		//数据库姓名重复校验
		boolean b = employeeService.checkUser(empName);
		if(b) {
			return Msg.success();
		}else {
			return Msg.fail().add("validate_msg", "名字已存在");
		}
	}
	
	/**
	 * 1.支持JSR303校验
	 * 2.导入Hibernate-validator包
	 * 员工保存
	 * @return
	 */
	@RequestMapping(value="/emps",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			//校验失败，应该返回失败，在模态框中显示校验失败的错误信息
			Map<String,Object> map = new HashMap<String,Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {			
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	/**
	 * 导入jackson包，将对象转为json字符串
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn) {
//		引入PageHelper分页插件，在查询之前只需要调用，传入页码及每页大小
		PageHelper.startPage(pn, 5);
		//startPage后面紧跟的查询就是一个分页查询
		List<Employee> emps =  employeeService.getAll();
		//使用PageInfo包装查询后的结果，里面封装了详细信息，包括查询出的信息，只需将PageInfo交给页面
		//传入连续显示的页数
		PageInfo pageInfo = new PageInfo(emps,5);
		return Msg.success().add("pageInfo", pageInfo);
	}
	
	/**
	 * 查询员工数据（分页查询）
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
		//引入PageHelper分页插件
		//在查询之前只需要调用,传入页码以及每页大小
		PageHelper.startPage(pn,5);
		//startPage后面紧跟的查询就是分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装查询后的结果,只需要将pageInfo交给页面
		//里面封装了详细的分页信息，包括查询结果
		//传入连续显示的页数
		PageInfo pageInfo = new PageInfo(emps,5);
		model.addAttribute("pageInfo", pageInfo);
		
		return "list";
	}
}
