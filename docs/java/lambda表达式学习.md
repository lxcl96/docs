package lambda;


import org.testng.annotations.Test;

import java.util.Comparator;
import java.util.function.Consumer;

/**
 * 总结：lambda接口只用于接口，且接口中只有一个抽象方法 ==>函数式接口
 * Lambda表达式只能用于实现功能接口，这些接口是具有单个抽象方法的接口。
 * lambda表达式    (Integer o1,Integer o2)  -> Integer.compare(o1,o2)
 *格式：
 *      ->：lambda操作符 或叫箭头操作符
 *      ->左边：lambda形参列表 （其实就是接口中的抽象方法的形参列表） 不能省略
 *      ->右边：lambda体 （其实就是方法体） {} 如果就一句话可以省略
 *
 * lambda使用6中情况：
 *
  *
 * lambda表达式的本质： 作为->箭头左边接口的对象
 *
 * @FileName:LambdaTest.class
 * @Author:ly
 * @Date:2022/5/17
 * @Description:
 */
 public class LambdaTest {


```java
@Test
//语法格式1：无参数，无返回值的写法
public void test1() {
    //正常写法
    Runnable r1 = new Runnable() {
        @Override
        public void run() {
            System.out.println("接口匿名内部类");
        }
    };

    r1.run();//直接调用不是多线程

    //lambda表达式写法
    Runnable r2 = () -> {System.out.println("lambda表达式 写法的 接口匿名内部类");}; //只有一个抽象函数，会自动找到不需要写
    r2.run();
}

@Test
//语法格式2：有参数，无返回值的写法
public void test2() {
    //正常写法
    Consumer<String> con = new Consumer<String>() {
        @Override
        public void accept(String s) {
            System.out.println("输入的参数是" + s);
        }
    };

    con.accept("11");
```


```java
    //lambda表达式写法
    Consumer<String> con1 = (String s) ->{System.out.println("输入的参数为" + s);};//如果就一个抽象方法，参数类型也可以省略不写
    con1.accept("22");
}

@Test
//语法格式3：参数数据类型可以省略，因为可由编译器推断得出，称为“类型推断”
public void test3() {

    //lambda表达式写法  test2优化
    Consumer<String> con1 = (s) ->{System.out.println("输入的参数为" + s);};//如果就一个抽象方法，参数类型也可以省略不写
    con1.accept("22");

}
```


```java
@Test
//语法格式4：参数个数只有一个时候，小括号可以省略()
public void test4() {

    //lambda表达式写法  test3优化
    Consumer<String> con1 = s -> {System.out.println("输入的参数为" + s);};//如果就一个抽象方法，参数类型也可以省略不写
    con1.accept("22");

}
```


```java
@Test
//语法格式5：有多个参数，多条执行语句，并且有返回值时
public void test5() {
    //正常写法
    Comparator<Integer> comparator = new Comparator<Integer>() {
        @Override
        public int compare(Integer o1, Integer o2) {
            return Integer.compare(o1,o2);
        }
    };

    System.out.println(comparator.compare(12,22));

    //lambda表达式写法
    Comparator<Integer> comparator1 = (o1,o2) -> {
        System.out.println("comparator内部");
        return Integer.compare(o1,o2);
    };

    System.out.println(comparator1.compare(22,12));

}

@Test
//语法格式6：当lambda表达式 函数体只有一条语句时，大括号和return都可以省略
public void test6() {

    //lambda表达式写法 test5优化
    Comparator<Integer> comparator1 = (o1,o2) -> Integer.compare(o1,o2);;

    System.out.println(comparator1.compare(22,12));

}
```
}
