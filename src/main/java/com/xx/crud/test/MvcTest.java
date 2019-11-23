package com.xx.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.github.pagehelper.PageInfo;
import com.xx.crud.bean.Employee;

/**
 * 使用Spring测试模块提供的测试请求功能，测试crud请求的正确性
 * 
 * @author lazy
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"file:src/main/webapp/WEB-INF/springDispatcherServlet-servlet.xml" })
public class MvcTest {

	// 传入SpringMVC的IOC
	@Autowired
	WebApplicationContext context;
//虚拟MVC请求，获取到处理结果
	MockMvc mockMvc;

	@Before
	public void initMockMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}

	@Test
	public void testPage() throws Exception {
		// 模拟请求，拿到返回值
		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "1")).andReturn();
		// 请求成功后，请求域中会有pageInfo,取出pageInfo进行验证
		MockHttpServletRequest request = result.getRequest();
		PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");

		System.out.println("当前页码：" + pageInfo.getPageNum());
		System.out.println("总页码：" + pageInfo.getPages());
		System.out.println("总记录数：" + pageInfo.getTotal());
		System.out.println("在页面需要连续显示的代码：");
		int[] nums = pageInfo.getNavigatepageNums();
		for (int i : nums) {
			System.out.print(" " + i);
		}
		System.out.println(); // 获取员工数据
		List<Employee> list = pageInfo.getList();
		for (Employee emp : list) {
			System.out.println("id:" + emp.getEmpId() + " name:" + emp.getEmpName() + " d_id:" + emp.getdId());
		}

		/*
		 * 显示结果： 当前页码：1 总页码：101 总记录数：502 在页面需要连续显示的代码： 1 2 3 4 5 id:1 name:赵一 d_id:1
		 * id:3 name:040480 d_id:1 id:4 name:0bb361 d_id:1 id:5 name:196f62 d_id:1 id:6
		 * name:268173 d_id:1
		 * 
		 * 如果某条数据的d_id=2，分页时就不会显示出来 测试部的员工信息会被放在所有数据的最后面
		 */

	}
}
