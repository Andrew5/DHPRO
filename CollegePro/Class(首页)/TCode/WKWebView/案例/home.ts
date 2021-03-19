//declare var $: any;
import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import $ from "jquery"; //intentional use of jQuery

@Component({
    selector: 'page-home',
    templateUrl: 'home.html'
})
export class HomePage {
    @ViewChild('divRef') divReference: ElementRef;
    @ViewChild('spanRef') spanReference: ElementRef;
    public action = null;

    callAMethod() {
        this.action = this.spanReference.attr('action')
    }
    constructor(public navCtrl: NavController) {

    }

    ngOnInit() {
        var mainDiv = document.getElementById("mainDiv");
        mainDiv.addEventListener("click", function (event) {
            console.log("Inside Event Listener");
            event.preventDefault();
            var link_id = $(event.target).attr("action");
            console.log("Actionid is:: " + link_id);
            //  this.actionid = link_id;
            //  var x = this.callpagedata();
        });
    }

    callpagedata() {
        console.log("callpagedata function fired,actionid is::", this.actionid)
    }

}