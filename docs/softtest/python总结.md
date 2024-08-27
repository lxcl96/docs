# 0. python模块和包

## 0.1 包

**一组python模块的集合.一个包就是一个目录,里面包含一组python模块文件和一个文件**`__init__.py`

+ `__init__.py`文件
  + python中package的标识,不能删除,否则就当成一个普通的py文件了
  + 定义`__all__`变量用来模糊导入
  + 编写python代码(不推荐,最好单独文件写)
+ 

## 0.2 模块

在Python中，模块是指包含Python代码的文件，并可以被导入到程序中进行使用。**一般来说一个python文件就是一个模块**

## 0.3 包和模块的区别

模块是一个单独的文件,一般就是`.py`文件.**模块和包的最大区别在于他们的结构和使用方式**

```python
# 模块
import 模块

# 包
import 包 # 导入全包(包内全模块)
from 包 import 模块
```

## 0.4 自己的模块/包安装到`site-packages`中



# 1. 本地脚本文件名和要导入的模块重名时

如本地文件为`selenium.py`要导入的是`selenium`模块(前提`selenium`已经安装)

+ 重命名本地文件`selenium-test.py`

+ **修改环境变量**,导入需要的`selenium`前去掉本脚本的环境(**缺点没有提示了**)

  ```python
  import sys
  import os
  
  script_path = os.path.dirname(os.path.abspath(__file__))
  
  sys.path.remove(script_path)
  
  import selenium  # 现在这将导入site-packages中的selenium
  
  # 你可以在这里继续编写你的代码
  print(selenium.__version__)
  ```

+ **修改环境变量的查找顺序(缺点没有提示了)**

  ```python
  import sys
  
  
  # 优先级提高
  sys.path.insert(0,'D:\\Code\\Code\\test\\reback\\reback\\.venv\\lib\\site-packages')
  print(sys.path)
  ```

  > 推荐第一种

# 2. python内置变量/魔法变量/特殊变量

## 2.1 全局内置变量

+ `__name__` 

  模块的名称,如果直接运行则是`__main__`,否则的话默认就是`文件/模块名`

+ `__file__`

  表示当前脚本文件的**相对路径或绝对路径,具体取决于执行的方式**

  ```python
  # 在目录`~`下 python scripts/myscripts.py`则`__file__`是`scripts/myscripts.py`而不是`~/scripts/myscripts.py
  print(__file__) #文件绝对或相对路径
  print(os.path.abspath(__file__))#获取文件绝对路径
  ```

+ `__doc__` 

  表示**模块,类或函数的文档字符串**`""""""`**中的内容**

  ```python
  # magic_vars.py
  """
  this is a demo test  1
  """
  
  import os
  import sys
  """
  this is a demo test  2
  """
  class demo1:
      """
      class demo1
      """
  
  def hello():
      """
      hello
      :return: NONE
      """
      pass
  
  __all__ = ['hello', 'demo1']
  ```

  ```python
  import magic_vars
  
  print("------------------------")
  print(magic_vars.__doc__) # this a demo test 1
  print(magic_vars.hello.__doc__) # hello \n :return: NONE
  print(magic_vars.demo1.__doc__) # class demo1
  ```

  > 注意: **模块的注释**`__doc__`**必须放在**`import`**上面才能输出,下面的不会输出**

+ `__package__`

  输出模块的包名,如果模块不属于任何包,则为`None`. 默认是当前模块的包

  ```python
  import os
  from selenium import webdriver
  
  print(__package__) #None
  print(os.__package__) # (啥也没有)
  print(webdriver.__package__) #selenium.webdriver
  ```

+ `__path__` 

  **包的搜索路径只对包有效**

  ```python
  from selenium import webdriver
  
  print(__path__)# 如果是模块会直接报错 NameError: name '__path__' is not defined
  print(webdriver.__path__) # 输出包的路径(虚拟环境或全局看你实际用哪个)
  ```

+ `__cached__`

  **显示已编译字节码的模块或包的缓存路径,一般为**`.pyc`

  ```python
  import magic_vars
  import os
  
  print(magic_vars.__cached__)
  print(os.__cached__)
  ```

## 2.2 类和对象的内置变量

+ `__module__`

  **类,对象,函数定义所在的模块名称**

  ```python
  import magic_vars
  
  print(magic_vars.demo1.__module__)# 输出magic_vars
  print(magic_vars.hello.__module__)# 输出magic_vars
  ```

+ `__dict__`

  **输出类或模块的属性字典**

  ```python
  import magic_vars
  
  print(magic_vars.__dict__)#输出模块的内部字典信息
  print(magic_vars.demo1.__dict__)# 输出类的内部字典信息
  print(magic_vars.hello.__dict__)# 函数无此属性为{}
  ```

+ `__class__`

  **输出变量的**`class`**类型,及是什么类型的**

  ```python
  import magic_vars
  
  a=1
  print(magic_vars.__class__) # <class 'module'>
  print(magic_vars.demo1.__class__) # <class 'type'>
  print(magic_vars.hello.__class__) # <class 'function'>
  print(a.__class__)# <class 'int'>
  ```

+ `__bases__`]

  **输出类的父类**

  ```python
  import magic_vars
  class demo2(magic_vars.demo1):
      pass
  
  
  print(magic_vars.demo1.__bases__)# (<class 'object'>,)
  print(demo2.__bases__)# (<class 'magic_vars.demo1'>,)
  ```

+ `__mro__`

  **输出指定类其内部方法的解析顺序(一般都是从本类到基类)**

  ```python
  import magic_vars
  class demo2(magic_vars.demo1):
      pass
  
  print(demo2.__mro__) # (<class '__main__.demo2'>, <class 'magic_vars.demo1'>, <class 'object'>)
  ```

+ `__subclasses__`

  **输出类的所有子类(其实应该是方法而不是类)**

## 2.3 函数和方法的内置变量

+ `__code__`

  **函数运行时的编译地址**

+ `__defaults__`

  **函数的默认参数值元组**

  ```python
  import magic_vars
  def add(x=1,y=2):
  
      return x+y;
  print(add.__code__) #<code object add at 0x000001A57CE43470, file "D:\Code\Code\test\reback\reback\test\variable.py", line 28>
  print(add.__defaults__)# (1, 2)
  ```

+ `__globals__`

  **输出函数的全局字典变量**

+ `__closure__`

  **用于检查函数是否是闭包并访问闭包的自由变量 ** //todo

  ```python
  def outer():
      x = 1
      def inner():
          return x
      return inner
  print(outer().__closure__) # (<cell at 0x000001D6CEA956F0: int object at 0x000001D6CE9700F0>,)
  ```

  > **闭包**是指一个函数中包含了对在函数外部定义的非全局变量的引用，然后该函数被返回或者传递给另一个函数。 
  >
  > 当一个函数是闭包时，它的`__closure__`属性将返回一个包含了对自由变量的引用的元组，如果函数不是闭包，`__closure__`将返回None。

+ `__annotation__`

## 2.4 其他内置变量

+ `__builtins__`

  获取内置模块,即不导入任何包默认支持的函数功能或类

  ```python
  print(dir(__builtins__))
  # ['ArithmeticError', 'AssertionError', 'AttributeError', 'BaseException', 'BlockingIOError', 'BrokenPipeError', 'BufferError', 'BytesWarning', 'ChildProcessError', 'ConnectionAbortedError', 'ConnectionError', 'ConnectionRefusedError', 'ConnectionResetError', 'DeprecationWarning', 'EOFError', 'Ellipsis', 'EncodingWarning', 'EnvironmentError', 'Exception', 'False', 'FileExistsError', 'FileNotFoundError', 'FloatingPointError', 'FutureWarning', 'GeneratorExit', 'IOError', 'ImportError', 'ImportWarning', 'IndentationError', 'IndexError', 'InterruptedError', 'IsADirectoryError', 'KeyError', 'KeyboardInterrupt', 'LookupError', 'MemoryError', 'ModuleNotFoundError', 'NameError', 'None', 'NotADirectoryError', 'NotImplemented', 'NotImplementedError', 'OSError', 'OverflowError', 'PendingDeprecationWarning', 'PermissionError', 'ProcessLookupError', 'RecursionError', 'ReferenceError', 'ResourceWarning', 'RuntimeError', 'RuntimeWarning', 'StopAsyncIteration', 'StopIteration', 'SyntaxError', 'SyntaxWarning', 'SystemError', 'SystemExit', 'TabError', 'TimeoutError', 'True', 'TypeError', 'UnboundLocalError', 'UnicodeDecodeError', 'UnicodeEncodeError', 'UnicodeError', 'UnicodeTranslateError', 'UnicodeWarning', 'UserWarning', 'ValueError', 'Warning', 'WindowsError', 'ZeroDivisionError', '__build_class__', '__debug__', '__doc__', '__import__', '__loader__', '__name__', '__package__', '__spec__', 'abs', 'aiter', 'all', 'anext', 'any', 'ascii', 'bin', 'bool', 'breakpoint', 'bytearray', 'bytes', 'callable', 'chr', 'classmethod', 'compile', 'complex', 'copyright', 'credits', 'delattr', 'dict', 'dir', 'divmod', 'enumerate', 'eval', 'exec', 'exit', 'filter', 'float', 'format', 'frozenset', 'getattr', 'globals', 'hasattr', 'hash', 'help', 'hex', 'id', 'input', 'int', 'isinstance', 'issubclass', 'iter', 'len', 'license', 'list', 'locals', 'map', 'max', 'memoryview', 'min', 'next', 'object', 'oct', 'open', 'ord', 'pow', 'print', 'property', 'quit', 'range', 'repr', 'reversed', 'round', 'set', 'setattr', 'slice', 'sorted', 'staticmethod', 'str', 'sum', 'super', 'tuple', 'type', 'vars', 'zip']
  ```

  

# 3. python内置方法/魔法方法/特殊方法

# 4. `*args`和`**kwargs`

+ `*args` **表示不定数量的位置参数**
+ `**kwargs` **表示接受关键字参数,并解析为字典dict来处理**

```python

def process_data(*args, **kwargs):
    for arg in args:
        print(f"Positional argument: {arg}")

    for key, value in kwargs.items():
        print(f"Keyword argument: {key} = {value}")

process_data(1, 2, 3,[123,456],{"key":"value"}, name="Alice", age=25)
# 输出：
# Positional argument: 1
# Positional argument: 2
# Positional argument: 3
# 	Positional argument: [123, 456]
# Positional argument: {'key': 'value'}
# Keyword argument: name = Alice
# Keyword argument: age = 25
```

# 5. python基本数据类型

+ Number 数字
+ String 字符串
+ bool 布尔类型
+ List  列表
+ Tuple 元组
+ Set  集合
+ Dictionary 字典 

**不可变数据类型:** Number,String,Tuple

**可变数据类型:** List,Set,Dictionary

> 可变数据类型 ：当该数据类型的对应变量的值发生了改变，那么它对应的内存地址不发生改变，对于这种数据类型，就称可变数据类型。

# 6. yield,next(),send()

**带yield关键字的函数是生成器generator,而不是简单的函数了.**

+ `yield`类似于`return`,运行到`yield`就返回结果(**但是会记住执行到的位置,方便下一次继续调用**)
+ `next(生成器)`从上一次`yield`的**下一条代码**的地方继续往下走
+ `生成器.send(值)`表示从上一次`yield`的**自身代码,并将值传递给yield的接收者**继续往下走

```python
#next函数
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(next(g))
"""
//输出如下
starting...
4
********************
res:None //这是None因为yield返回4中断了,没有继续将值传递给res
4
"""
# send函数
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(g.send(7))

"""
//输出如下
starting...
4
********************
res:7 //这是因为send函数传递值给res
4
"""
```

> 参考地址: [python中yield的用法详解——最简单，最清晰的解释_yield python-CSDN博客](https://blog.csdn.net/mieleizhi0522/article/details/82142856)
>
> 评论区第一个例子:
>
> + print返回值为None
> + `for in 返回值为None:`会继续执行内部的代码,不会报错

# 7. 迭代器和生成器的区别

## 7.1 迭代器iterator

迭代器用于**迭代取值**的工具,是一个可以记住**遍历的位置**的对象

### 7.1.1 可迭代对象iterable

通过**索引**的方法进行迭代取值,实现简单,但只适用于**序列类型:字符串,列表,元组**.

对于**没有索引的字典,集合等非序列类型**,必须找到一种**不依赖索引进行迭代取值**的方式,这就是迭代器.

***字符串,列表,元组,字典,集合,包括打开的文件都是可以迭代对象***

> **迭代器对象iterator**可以使用`for`循环取值,也可以使用`next()`或`send()`函数取值遍历(**send函数包含next函数**)

### 7.1.2 迭代器对象iterator

迭代器对象是指内置有`iter`和`next`方法的对象,打开的文件本身就是一个迭代器对象.

+ `iter(列表或元组或字符串)`得到的是**迭代器本身**
+ `next(迭代器实例)`得到的是**迭代器中的下一个值**

```python
goods=['mac','lenovo','acer','dell']
i=iter(goods) #每次都需要重新获取一个迭代器对象
while True:
    try:
        print(next(i))
    except StopIteration: #捕捉异常终止循环
        break
#简写为
goods=['mac','lenovo','acer','dell']
for item in goods:   
    print(item)
```

**for循环**又称为**迭代循环**，in后可以跟任意可迭代对象.

> for 循环在工作时：
>
> 首先会调用可迭代对象goods内置的iter方法拿到一个迭代器对象，
>
> 然后再调用该迭代器对象的next方法将取到的值赋给item,执行循环体完成一次循环，
>
> 周而复始，直到捕捉`StopIteration`（停止迭代），结束迭代。

### 7.1.3 迭代器的优缺点

***优点:***

+ 为**序列**和**非序列**类型提供了一种**统一的迭代取值方式**
+ **惰性计算**迭代器对象表示是一个数据流,可以只在需要时才调用next计算下一个值.
+ **迭代器同一时间在内存中只有一个值**,因此可以存放无限大的数据流.**节约内存**. 其他;类型如列表,元组是把所有数据存放在内存中

***缺点:***

+ 必须取尽,否则无法得到迭代器的长度
+ 只能取下一个值,**不能回到最开始或上一个元素**

## 7.2 生成器generator

使用`yield`的函数成为生成器generator. `yield函数被调用是返回生成器自身,而不是调用函数,除非用了next或send`

**生成器是一个返回迭代器的函数,只能用于迭代操作,即生成器generator就是一个自定义迭代器**

### 7.2.1 yield原理

yield能够**临时挂起**当前函数,记住**其上下文(包括局部变量,待决定的try-except)**,将参数控制权返回给调用者.

当下一次再调用其所在的生成器时,会恢复保存的上下文,继续执行剩下的语句,直到再次遇到yield或退出(**可以有多个yield**).

### 7.2.2 yield和return的区别

yield可以用于返回值,但是和return不一样

+ 函数遇到return就结束了,销毁上下文(弹出栈),将控制权返回给调用者
+ yield可以保存函数的运行状态,并挂起函数,用于返回多次值

因此,yield执行流控制的函数成为**生成器函数**,而return执行流控制的函数时**普通函数**

### 7.2.3 yield的优点

+ 精简代码
+ 降低内存占用,提高性能(**惰性加载,流式读取**)

# 8. with

with 用于异常处理,封装了`trt..excep..finally`的编码范式. 一般用于文件管理,出现异常也会关闭文件释放流

with语句实现原理建立在上下文管理器之上.上下文管理器是一个实现`__enter__`和`__exit__`方法的类.使用with语句确保在嵌套块的末尾调用`__exit__`方法

# 9. @staticmethod和@classmethod

`@staticmethod`静态方法和`@classmethod`类方法都可以通过**类.方法()**来调用,不同的地方在于类方法可以获取类的一些静态变量成员(**有个cls参数可以访问自身**),而静态方法不可以.

# 10. python内置函数

+ python2内置函数[Python 内置函数 | 菜鸟教程 (runoob.com)](https://www.runoob.com/python/python-built-in-functions.html)
+ python3内置函数[Python3 内置函数 | 菜鸟教程 (runoob.com)](https://www.runoob.com/python3/python3-built-in-functions.html)

# 11. 装饰器

使用`@`将一个函数装饰在目标函数或类上,用于修改函数功能

## 11.1 多装饰器顺序

执行顺序其实就是

+ `f=deco_1(deco_2(deco_3(test_hello)))`
+ `f(1,[2,3],{"key":"name"}, key=2)` (可以将1和2合二为一)

> 总结: **从下而上wrapper包裹,自上而下执行run**(类似于代理的前后置处理器)

```python
1,[2,3],{"key":"name"}, key=2def deco_1(func):
    print("deco_1开始")

    def call_1(*args, **kwargs):
        print("call_1执行前")
        func(*args, **kwargs)
        print("call_1执行后")

    print("deco_1结束")
    return call_1


def deco_2(func):
    print("deco_2开始")

    def call_2(*args, **kwargs):
        print("call_2执行前")
        func(*args, **kwargs)
        print("call_2执行后")

    print("deco_2结束")
    return call_2


def deco_3(func):
    print("deco_3开始")

    def call_3(*args, **kwargs):
        print("call_3执行前")
        func(*args, **kwargs)
        print("call_3执行后")

    print("deco_3结束")
    return call_3


@deco_1
@deco_2
@deco_3
def test_hello(*args, **kwargs):
    print(f"test_hello开始    args={args} kwargs={kwargs}")


if __name__ == '__main__':
    test_hello(1,[2,3],{"key":"name"}, key=2)
    # 等价于去掉@deco_1 @deco_2 @deco_3的
    #deco_1(deco_2(deco_3(test_hello)))(1,[2,3],{"key":"name"}, key=2)
"""
输出结果:
deco_3开始 #自下而上wrapper
deco_3结束
deco_2开始
deco_2结束
deco_1开始
deco_1结束 
call_1执行前 #自上而下执行run
call_2执行前
call_3执行前
test_hello开始
call_3执行后
call_2执行后
call_1执行后
"""
    
```

## 11.2 装饰器参数

如果需要写入装饰器参数,那么必须极少需要具有**三级def函数,二级return**

> 总结:**再包装一次def函数**

```python
# 最外面一层接受装饰器参数,第二层接受包装后的test_deco_1函数,第三层为实际的调用
def detail(key):
    """detail函数输出详情"""
    print(f"装饰器参数key={key}")

    def detail_wrapper(func):
        def call_1(*args, **kwargs):
            print(f"开始执行{func.__name__} args={args} kwargs={kwargs}")
            # print(f"开始执行{func} args={args} kwargs={kwargs}")
            func(*args, **kwargs)
            print(f"{func.__name__}执行完成")

        return call_1 #返回

    return detail_wrapper #返回


@detail("hello")
def test_deco_1(*args, **kwargs):
    print(11111)


if __name__ == '__main__':
    test_deco_1(1)

"""
输出
装饰器参数key=hello
开始执行test_deco_1 args=(1,) kwargs={}
11111
test_deco_1执行完成
"""
```

## 11.3 显示被装饰函数的细节信息

被装饰的函数会改变原来的信息如`__name__`,`__doc__`变为实际的调用函数,如果要保留原来的信息,两种方法

```python
def detail(func):
    def call(*args, **kwargs):
        print(f"{func.__name__}开始")
        func(*args, **kwargs)
        print(f"{func.__name__}结束")
    
    return call
#@detail
def hello(*args, **kwargs):
    """hello函数的doc"""
    des = "hello函数的属性"
    print(f"参数为 args={args}  kwagrs={kwargs}")


if __name__ == '__main__': # 正常不使用装饰器输出  #使用装饰器
    print(hello.__name__) # hello				call
    print(hello.__doc__) # hello函数的doc		  None
    print(hello.__dict__) #{}					{}
```

### 11.3.1 手动更新

手动更改,输出和不使用装饰器完全一样(**当然其余没指定的,肯定不一样**)

```python
def detail(func):
    def call(*args, **kwargs):
        print(f"{func.__name__}开始")
        func(*args, **kwargs)
        print(f"{func.__name__}结束")
    call.__name__ = func.__name__ #手动赋值重新更新
    call.__doc__ = func.__doc__ #手动赋值重新更新
    call.__dict__.update(func.__dict__) #手动赋值重新更新
    return call
```

### 11.3.2 `wraps`装饰器

```python
from functools import wraps
def detail(func):
    @wraps(func) #参数为被装饰器的函数,即要恢复的函数
    def call(*args, **kwargs):
        print(f"{func.__name__}开始")
        func(*args, **kwargs)
        print(f"{func.__name__}结束")
    return call
"""
输出  
hello
hello函数的doc 
{'__wrapped__': <function hello at 0x0000027DFADA63B0>} # 这里不一样了
"""
```

