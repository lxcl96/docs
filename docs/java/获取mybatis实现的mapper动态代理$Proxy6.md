```java
System.getProperties().put("jdk.proxy.ProxyGenerator.saveGeneratedFiles", "true");
	//System.getProperties().put("sun.misc.ProxyGenerator.saveGeneratedFiles", "true");

	UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

	byte[] newProxyClass = ProxyGenerator.generateProxyClass("$Proxy6", userMapper.getClass().getInterfaces());
	System.out.println(newProxyClass);
	FileOutputStream fileOutputStream = null;
	try {
		fileOutputStream = new FileOutputStream(new File("$Proxy6.class"));
		try {
			fileOutputStream.write(newProxyClass);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (fileOutputStream != null) {
				try {
					fileOutputStream.flush();
					fileOutputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	} catch (FileNotFoundException e) {
		e.printStackTrace();
	}
```



