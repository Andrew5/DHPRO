// model.ts 解析版本
var parserVersion = "1.0.0";
// 命名空间
var moduleID = "com.zkty.module.min";
// JS模块名称
var JSModule = "@zkty-team/x-engine-module-min";
var conf = {
    args: {},
    permissions: {
        X_USER_INFO: "READ",
        X_LBS: "READ_WRITE",
        X_PHOTO: "READ"
    }
};
function setNameD2222(arg) {
    window.setNameD2222 = function () {
        min.setNameD2222().then(function (res) { });
    };
}
function setNameC(arg) {
    if (arg === void 0) { arg = { title: "title", titleColor: "#000000", titleSize: 16 }; }
    window.setNameC = function () {
        min.setNameC().then(function (res) { });
    };
}
function setNameD(arg) {
    if (arg === void 0) { arg = { title: "title", titleColor: "#000000", titleSize: 16 }; }
    window.setNameD = function () {
        min.setNameD().then(function (res) { });
    };
}
function printLabel(arg) {
    if (arg === void 0) { arg = {
        label: "", complete: ""
    }; }
    window.printLabel = function () {
        min.printLabel({
            label: "你好，李焕英",
            complete: "2021"
        }).then(function (res) {
            document.getElementById("debug_text").innerText = JSON.stringify(res);
        });
    };
}
function createSquare(arg) {
    if (arg === void 0) { arg = {
        color: "", width: ""
    }; }
    window.createSquare = function () {
        min.createSquare({
            colour: "red",
            width: 100
        }).then(function (res) {
            document.getElementById("debug_text").innerText = JSON.stringify(res);
        });
    };
}
function noArgNoRet(arg) {
    window.noArgNoRet = function () {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        // document.getElementById("debug_text").innerText = "ret:" + "测试";
        document.getElementById("debug_text").innerText = title;
    };
}
function locate(args) {
    if (args === void 0) { args = {
        type: "BMK09LL"
    }; }
    window.locate = function () {
        min.locate({
            __event__: function (res) {
                //GeoLocationResDTO
                res = JSON.parse(res);
                document.getElementById("debug_text").innerText = "long,lat,locs:" + res["longitude"] + res["latitude"] + res["country"] + res["province"] + res["city"] + res["district"] + res["street"];
                return res;
            }
        });
    };
}
function repeatReturn__event__(args) {
    window.repeatReturn__event__ = function () {
        min.repeatReturn__event__({
            __event__: function (res) {
                document.getElementById("debug_text").innerText =
                    "主动调用 js 入参：" + JSON.stringify(res);
                return res;
            }
        });
    };
}
function createSquare(config) {
    window.createSquare = function () {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        min.createSquare({
            __event__: function (res) {
                document.getElementById("debug_text").innerText = res;
            }
        })
            .then(function (res) {
            document.getElementById("debug_text").innerText = typeof (res) + ":" + JSON.stringify(res);
        });
    };
    var newSquare = { color: "white", area: 100 };
    if (config.color) {
        // Error: Property 'clor' does not exist on type 'SquareConfig'
        newSquare.color = config.clor;
    }
    if (config.width) {
        newSquare.area = config.width * config.width;
    }
    return newSquare;
}
