/*
TypeScript支持JavaScript的新特性，比如支持基于类的面向对象编程
*/
//在构造函数的参数上使用public等同于创建了同名的成员变量。
function greeter(person) {
    return "Hello, " + person.firstName + " " + person.lastName;
}
var user = { firstName: "Jane", lastName: "User" };
document.body.innerHTML = greeter(user);
