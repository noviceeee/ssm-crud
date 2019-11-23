package com.xx.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.xx.crud.bean.Employee;
import com.xx.crud.dao.DepartmentMapper;
import com.xx.crud.dao.EmployeeMapper;

/**
 * 测试dao层的工作
 * 
 * @author lazy Spring的项目推荐使用Spring的单元测试，可以自动注入需要的组件 1.导入Spring Test模块
 *         2.@ContextConfiguration指定Spring配置文件的位置 3.直接autowired要使用的组件即可
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class MapperTest {
	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;

	/** 测试DepartmentMapper */
	@Test
	public void testCRUD() {
		/*
		 * //创建ioc容器 ApplicationContext ioc = new
		 * ClassPathXmlApplicationContext("applicationContext.xml"); // 从容器中获取mapper
		 * DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
		 */

		// 1.插入几个部门
		// departmentMapper.insertSelective(new Department(null, "开发部"));
		// departmentMapper.insertSelective(new Department(null, "测试部"));
		
		//生成员工数据，测试员工插入		
//		employeeMapper.insertSelective(new Employee(null,"赵一","女","13579@qq.com",1));
//		employeeMapper.insertSelective(new Employee(null,"王二","男","123456@163.com",2));
//		
		//批量插入多个员工，使用可以使用批量操作的sqlSession
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0;i<500;i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null, uid, "男", uid+"@163.com", 1));
		}
	}
}
