package com.xx.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xx.crud.bean.Department;
import com.xx.crud.bean.Msg;
import com.xx.crud.service.DepartmentService;

/**
 * 处理和部门有关的请求
 * @author lazy
 *
 */
@Controller
public class DepartmentController {

	@Autowired
	private DepartmentService departmentService;

	/**返回所有的部门信息
	 * @return
	 */
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts() {
		//查出的所有部门信息
		List<Department> depts = departmentService.getDepts();
		return Msg.success().add("depts", depts);
	}
}
