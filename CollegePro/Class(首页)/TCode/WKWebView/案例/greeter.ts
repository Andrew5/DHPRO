
/*
TypeScript支持JavaScript的新特性，比如支持基于类的面向对象编程
*/
//在构造函数的参数上使用public等同于创建了同名的成员变量。

class Student {
    fullName: string;
    constructor(public firstName: string, public middleInitial: string, public lastName: string) {
        this.fullName = firstName + " " + middleInitial + " " + lastName;
    }
}
 
interface Person {
    firstName: string;
    lastName: string;
}
 
function greeter(person : Person) {
    return "Hello, " + person.firstName + " " + person.lastName;
}
 
let user = new Student("Jane", "M.", "User");
document.body.innerHTML = greeter(user);

