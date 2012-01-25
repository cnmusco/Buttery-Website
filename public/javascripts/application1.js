var login_success = false;
var user_name = "";

//load after the page loads
$(document).ready(function()
{
    change_alert();
    reload_order_queue();
    buttons();
    see_butt_open();
}); 


function analytics()
{
    /*var str=window.location.href;
    var y=new RegExp("/home");
    var tmp=str.split('/');
    if(root || str.match(y))*/
    {
         var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-28607691-1']);
      _gaq.push(['_setDomainName', 'piersonbuttery.com']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    //}
}

function see_butt_open()
{
    var str=window.location.href;
    var y=new RegExp("/home");
    var tmp=str.split('/');
    var root=(tmp.length==4 && !tmp[3]);
    
    if((root || str.match(y)) && !butt_open1())
    {
        $("#submit_button1").html(' <div id=butt_closed> The Buttery is\nNot Open</div><div id=butt_closed1>The Buttery is Open Sunday-Thursday 10:30p-12:30a</div>');
    }
}


//reloads the order queue automatically
function reload_order_queue()
{
    var str=window.location.href;
        var y=new RegExp("/worker/orders");
    if(str.match(y))
        setTimeout("reload_order_queue1()", 90000);
}
function reload_order_queue1()
{
    var str=window.location.href;
    var y=new RegExp("/worker/orders");
    if(str.match(y))
    {
        $.ajax({
            type: "POST",
            url: "/order/refresh_queue",
            success: function(data)
            {
                $("#order_queue").html(data)
                setTimeout("reload_order_queue1()", 90000);
            }
        });
    }
}



function buttons()
{
    $("#about").click(function()
    {
            window.location = "/about"
    });
    //button link chnages
    $("#worker_view").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker");
        if(!(str.match(y)))
            window.location = "/worker/orders"
    });
    $("#account_info").click(function()
    {
        window.location = "/account"
    });
    $("#home").click(function()
    {
        window.location = "/home"
    });
    $("#up_inv").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker/update_inventory");
        if(!(str.match(y)))
            window.location = "/worker/update_inventory"
    });   
    $("#new_stuff").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker/manage_menu");
        if(!(str.match(y)))
            window.location = "/worker/manage_menu"
    });
    $("#manual").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker/manual");
        if(!(str.match(y)))
            window.location = "/worker/manual"
    });   
    
    //reset phone number
    $("#number_reset").click(function()
    {
        $.ajax({
            type: "POST",
            url: "/account",
            data: ({reset: 1}),
            success: function()
            {
                window.location = "/account"   
            }
            });
    });
    
    
    
    //log in and sign up buttons
    $("#log_in").click(function()
    {
        //If the other menu is showing, hide it before showing this one
        if($("#sign_up_menu").css("display")!="none")
        {
            $("#sign_up_menu").hide();
        }
        if($("#send_username").css("display")!="none")
        {
            $("#send_username").hide();
        }
        
        if($("#log_in_menu").css("display")=="none")
        {
            $("#invalid_login").hide();
            $("#invalid_login5").hide();
            $("#invalid_login7").hide();
            
            $('#pwd').val('');
            $('#username').val('');
            $("#log_in_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
    });
	
	$("#login_form").submit(function(){
        $("#invalid_login").hide();
        $("#invalid_login5").hide();
        $("#invalid_login7").hide();
        
        if($("#username").val() && $("#pwd").val())
        {
            $.ajax({
            type: "POST",
            url: "/user_accounts/login",
            data: ({username: $("#username").val(),
                    pwd: $("#pwd").val()}),
			success: function() {
				if(login_success) {
					$("#log_in_menu").toggle();
					$("#nonworker_message").text("");
					$("#welcome-message").html("Welcome, " + user_name);
					$("#logged_in").show();
					$("#logged_out").hide();
					
				}
			}
            });
        }
        else
        {
            $("#invalid_login").show();
        }
		return false;
    });
    
    
    $("#sign_up_butt").click(function()
    {
        //If the other menu is showing, hide it before showing this one
        if($("#log_in_menu").css("display")!="none")
        {
            $("#log_in_menu").hide();
        }
        if($("#send_username").css("display")!="none")
        {
            $("#send_username").hide();
        }
        
        if($("#sign_up_menu").css("display")=="none")
        {
            $("#invalid_login1").hide();
            $("#invalid_login2").hide();
            $("#invalid_login3").hide();
            $("#invalid_login4").hide();
            $("#invalid_login6").hide();
            $('#email1').val('');
            $('#pwd0').val('');
            $('#pwd1').val('');
            $('#username1').val('');
            $("#sign_up_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#sign_up_menu").slideUp('fast', function(){});
        }
    });
    
	$("#sign_up_form").submit(function()
    {
        $("#invalid_login1").hide();
        $("#invalid_login2").hide();
        $("#invalid_login3").hide();
        $("#invalid_login4").hide();
        $("#invalid_login6").hide();
        
        if(sign_up_validator())
        {
            $("#invalid_login2").show();
        }
        else if($("#email1").val() && $("#pwd0").val() && $("#pwd1").val() && $("#username1").val())
        {
			console.log("ajaxing");
            $.ajax({
            type: "POST",
            url: "/user_accounts/signup",
            data: ({email: $("#email1").val(),
                    username: $("#username1").val(),
                    pwd: $("#pwd1").val()})
            });
        }
        else
        {
            $("#invalid_login1").show();
        }
		return false;
    });
    
    
    
    //functions for adding, subtracting and emptying inventroy 
    //from worker inv page
    $(".add_item").live('click', function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $.ajax({
            type: "POST",
            url: "add_inv",
            data: ({id: ing_id})
        });
        
    });
    $(".sub_item").live('click', function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $.ajax({
            type: "POST",
            url: "sub_inv",
            data: ({id: ing_id})
        });
    });
    $(".empty_item").live('click', function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $(ais).html(0+'');
        $.ajax({
            type: "POST",
            url: "empty_inv",
            data: ({id: ing_id})
        });
    });
    
    
    //Buttons for Menu Manager
    $("#nmi_submit").live('click', function()
    {
        var num_ings=parseInt($("#hidden_num_of_ings").text(), 10);
        var ids=new Array();
        var clas=$("#add_class").val();
        if(clas=="other")
            clas=$("#nmi_new_class").val();
        ids=$("#hidden_id_of_ings").text().split("  ");
        var ings=new Array(), vits=new Array;
        var name, clas, error=0, empty=0;
        if(!(name=$("#nmi_name").val()))
            alert("Enter A Name");
        else
        {
            for(var i=1; i<=num_ings; i++)
            {
                var j=parseInt(ids[i], 10);
                ings[i]=(!!$("#nmi_ing_"+j+":checkbox:checked").val());
                vits[i]=(!!$("#nmi_ing_"+j+"_vital:checkbox:checked").val());
                if(!((ings[i] && vits[i]) || !vits[i]))
                    error=1;
                if(ings[i])
                    empty++;
            }
            if(error)
                alert("An Ingredient Cannot Be Vital If It Is Not Included");
            else if(!empty)
                alert(name + " needs ingredients");
            else
            {
                var ing_send=new Array();
                var vit_send=new Array();
                var count=0, last_val=1;
                for(var i=1; i<=num_ings; i++)
                {
                    var val=parseInt(ids[i], 10);
                    if(ings[i])
                    {
                        ing_send[count++]=val;
                        if(vits[i])
                            vit_send[val]=1;
                        else
                            vit_send[val]=0;
                        last_val=val;
                    }
                }
                for(var i=0; i<last_val; i++)
                {
                    if(vit_send[i]!=1)
                        vit_send[i]=0;
                }
                $.ajax({
                    type: "POST",
                    url: "add_items",
                    data: ({
                        name: name,
                        clas: clas,
                        ings: ing_send.join(';'),
                        flag: 4,
                        vits: vit_send.join(';')}),
                        success: function(data)
                                {
                                    $("#edit_items").html(data);
                                }
                });
                $("#nmi_name").val("")
                for(var i=1; i<=num_ings; i++)
                {
                    var j=parseInt(ids[i], 10);
                    $("#nmi_ing_"+j+":checkbox").removeAttr('checked');
                    $("#nmi_ing_"+j+"_vital:checkbox").removeAttr('checked');
                }
                $("#nmi_new_class").val("");
                alert("The " + name + " has been added to the inventory");
            }
        }
    });
    $("#add_class").live('change', function()
    {
        if($("#add_class").val()=="other")
            $("#nmi_new_class").show();
        else
            $("#nmi_new_class").hide();
    });
    $("#ni_submit").live('click', function()
    {
        var name, quant, unit, thresh;
        if((name=$("#ni_name").val()) && (quant=$("#ni_amount").val()) && parseInt(quant)==quant && (thresh=$("#ni_thresh").val()) && parseInt(thresh)==thresh&& (unit=$("#ni_unit").val()))
        {
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({
                    name: name,
                    flag: 5,
                    current_item: $("#edit_item_changer").val(),
                    amount: quant,
                    unit: unit,
                    thresh: thresh}),
                success: function(data)
                        {
                            $("#new_item").html(data);
                        }
            });
            
            $("#ni_name").val('');
            $("#ni_amount").val('');
            $("#ni_unit").val('');
            alert(name + " has been added to the inventory");
        }
        else
            alert("Invalid Input");
    });
    
    $("#edit_item_changer").live('change', function()
    {
        edit_remove($("#edit_item_changer").val());
    });
    
    
    //buttons for edit and delete menu items
    $("#update_menu_button").live('click',function()
    {
        var ings_to_be_removed=new Array();
        var ings_to_be_added=new Array();
        var vits_to_be_added=new Array();
        
        var ids=$("#hidden_id_of_ings").text().split("  ");
        var num_ings=parseInt($("#hidden_num_of_ings").text(), 10);
        var error=0;
        
        for(var i=1; i<=num_ings; i++)
        {
            cur_id=parseInt(ids[i], 10);
            var remove="#remove_ing_" + cur_id;
            var add="#add_ing_" + cur_id;
            var add_vit="#add_ing_" + cur_id + "_vital";
            
            //go through the remove
            if($(remove).attr('checked'))
                ings_to_be_removed.push(cur_id);
            
            //go through the additions
            if($(add).attr('checked'))
            {
                ings_to_be_added.push(cur_id);
                if($(add_vit).attr('checked'))
                    vits_to_be_added[cur_id]=1;
            }
            else if($(add_vit).attr('checked'))
                error=1;
        }
        for(var i=0; i<=parseInt(ids[num_ings], 10); i++)
        {
            if(!vits_to_be_added[i])
                vits_to_be_added[i]=0;
        }
        
        if(error)
            alert("An Ingredient Cannot Be Vital if it is Not Included");
        else if(ings_to_be_removed.length===0 && ings_to_be_added.length===0)
        {
            alert("You Have Not Made Any Changes");
        }
        else
        {
            //update the item
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({
                    flag: 2,
                    current_item: $("#edit_item_changer").val(),
                    remove: ings_to_be_removed.join(';'),
                    add: ings_to_be_added.join(';'),
                    vits: vits_to_be_added.join(';')}),
                    success: function(data)
                            {
                                $("#edit_items").html(data)
                                alert($('#current_itm_'+$("#edit_item_changer").val()).attr('class')+' was updated');
                            }
            });
        }
    });
    $("#delete_menu_button").live('click', function()
    {
        if(confirm("Are You Sure You Want To Delete This Item?"))
        {
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({current_item: $("#edit_item_changer").val(),
                        flag: 3}),
                success: function(data)
                    {
                        alert($('#current_itm_'+$("#edit_item_changer").val()).attr('class')+' was deleted');
                        $("#edit_items").html(data)
                    }
            });
        }
    });
    
    $(".item_names_public").click(function(event)
    {
        var val="#pub_ings_" + event.target.name;
        $(val).toggle();
    });
    
    
    //submit button on public page
    $("#submit_order").click(function()
    {
        var order=new Array();
        var last_parent='';
        $('.pub_ings_in_itms').each(function()
        {
            if($(this).is(":visible"))
            {
                var parent=$(this).attr('id');
                var value=$(this).val();
                if(last_parent!=parent)
                {
                    var tmp=order.pop();
                    if(tmp!=('|'+last_parent) && tmp)
                        order.push(tmp);
                    order.push('|'+parent);
                }
                if(value!=0)
                    order.push(','+$(this).attr('name')+':'+value);
                last_parent=parent;
            }
        });
    
        var butt_open=butt_open1();//becomes 1 if the buttery is open
        
        if(butt_open)
        {
             $.ajax({
                    type: "POST",
                    url: "/order/add_order",
                    data: ({order: order.join(''),
                    notes: $('#order_notes').val()})
                });
        }
        else
            alert("The Buttery Is Not Open At This Time");
    });
    
    
    //order button on worker page
    $('#orders').click(function()
    {
        window.location="/worker/orders";
    });
    //begin making order button

    $(".order_is_cooking").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:0,
                        id: $(this).attr('id')}),
		        success: function() {
		              window.location="/worker/orders";
		         }
						
            });
    });
    
    $(".order_is_cooking1").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:5,
                        id: $(this).attr('id')}),
				success: function() {
				      window.location="/worker/orders";
				 }
            });
    });
    //finished order button
    $(".order_is_done").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:1,
                        id: $(this).attr('id')}),
				        success: function() {
				              window.location="/worker/orders";
				         }
            });
    });
    //finished order, customer is in buttery
    $(".order_is_done1").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:2,
                        id: $(this).attr('id')}),
				        success: function() {
				              window.location="/worker/orders";
				         }
            });
    });
    //pickup order button
    $(".order_is_picked_up").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:2,
                        id: $(this).attr('id')}),
				        success: function() {
				              window.location="/worker/orders";
				         }
            });
    });
    //finished order button
    $(".order_is_abandoned").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:3,
                        id: $(this).attr('id')}),
				        success: function() {
				              window.location="/worker/orders";
				         }
            });
    });
    
    //cancel order
    $(".worker_cancel_order").live('click', function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:4,
                        id: $(this).attr('id')}),
				        success: function() {
				              window.location="/worker/orders";
				         }
            });
    });
    
    
    //button for account manager
    $("#change_pwd").click(function()
    {
        var old_pwd, new_pwd;
        
        //ensure that fields are correctly entered
        if((old_pwd=$("#acc_old_pwd").val()) && (new_pwd=$("#acc_new_pwd1").val()) &&
                    new_pwd==$("#acc_new_pwd2").val() && new_pwd!=old_pwd)
        {
            $.ajax({
                type: "POST",
                url: "account/change_pwd",
                data: ({old_pwd: old_pwd,
                        new_pwd: new_pwd})
            });
        }
    });
    
    //reset password
    $("#forgot_pwd").click(function()
    {
        var unm = $("#username").val();
        if(!unm)
            alert("Please Enter Your Username");
        else
        {
            $.ajax({
                type: "POST",
                url: "/account/reset_pwd",
                data: ({username: unm})
            });
            alert("An Email Has Been Sent To You");
        }
    });

	//Forgot Username
    $("#forgot_username").click(function()
    {
		$('#log_in_menu').hide();
		$('#send_username').show();
    });

    $("#send_username_button").click(function(){
		var us = $('#username_email').val()
		if(!us) {
        	alert("Please Enter Your Email");
		}
    	else {
        		$.ajax({
            		type: "POST",
           			url: "/account/send_username",
           			data: ({email: us})
        		});
			}
		});
		
		
    //log out
    $("#log_out").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/user_accounts/logout"
                });
    });
    
    
    //send stocking email
    $("#restock").click(function()
    {
        $("#choose_sender").toggle();
    });
    
    $("#send_stocking_email").click(function()
    {
        $.ajax({
            type: "POST",
            url: "/worker/restock",
            data: ({to: $("select option:selected").val() })
            });
            $("#choose_sender").toggle();
        
    });
    
    
    //cancel order on account page
    $('.acc_order_cancel').click(function()
    {
        $.ajax({
                type: "POST",
                url: "/account/cancel_order",
                data: ({ord_id: $(this).attr('id')})
        });
    });
    
    
    //when manual grill order is clicked
    $('.grill_button').click(function()
    {
        /*if(!$('#grill_ings_'+$(this).attr('id')).is(":visible"))
        {
            $('.grill_ings').hide();
            $('#grill_ings_'+$(this).attr('id')).show();
        }*/
        if(!$('#grill_ings_'+$(this).val()).is(":visible"))
        {
            $('.grill_ings').hide();
            $('#grill_ings_'+$(this).val()).show();
        }
        else
            $('.grill_ings').hide();
    });
    //place order
    $('.grill_submit_order').click(function()
    {
        var val=$(this).attr('id');
        var order=new Array, itm;
        order.push('|'+val);
        $('.wkr_ings_in_itms').each(function()
        {
            if($(this).attr('id')==val && $(this).val()!=0)
            {
                order.push(','+$(this).attr('name')+':'+$(this).val());
            }
        });
        
        $.ajax({
            type: "POST",
            url: "/order/add_manual_order",
            data: ({order: order.join('')}),
        });
    });
    
    
    
    
    //save phone number
    $('#new_num').click(function()
    {
        var num=$('#number').val();
        if (num.length==10 && !isNaN(num))
        {
            $.ajax({
                type: "POST",
                url: "/account",
                data: ({number: num}),
                success: function() {
                        window.location= '/account'
                }
            });
    	}
        else
            alert("Invalid Number");
    });
    
    //change contact options
    $('#contact_options').change(function()
    {
        $.ajax({
            type: "POST",
            url: "/account",
            data: ({acc: $("input:checked").val()})
        });
    });
    
    
    
    //update inventory search box
    $('#inventory_search').keyup(function()
    {
        filter();
    });
    //filter by quantity
    $('#inv_filter').change(function()
    {
        filter();
    });
    //filter by quantity
    $('#misc_inv_dropdown').change(function()
    {
        filter();
    });
}

function filter()
{
    $.ajax({
        type: "POST",
        url: "/worker/up_inv1",
        data: ({word: $('#inventory_search').val(),
                misc_ing: $('#misc_inv_dropdown').val(),
                flag: $('input:checked').val()}),
                success: function(data)
                {
                    $('#inventory_search').css('color', 'black');
                    $("#inv_to_update").html(data);
                },
                error: function()
                {
                    $('#inventory_search').css('color', 'red');
                }
    });
}


function sign_up_validator()
{
    //passwords match?
    if($("#pwd1").val() != $("#pwd0").val())
    {
        return 1;
    }
    
    //valid yale email address
    var email=$("#email1").val();
    var flag1=0;
    for(var i=0; i<email.length; i++)
    {
        var letter=email.charAt(i);

        if(flag1 && letter=='@')
        {
            return !email.substr(i)=="@yale.edu";
        }
        else if(letter=='.')
        {
            flag1=1;
        }
    }
    return 1;
}

//function updates the edit/remove section of the menu manger
function edit_remove(cur_itm)
{
    $.ajax({
        type: "POST",
        url: "add_items",
        data: ({flag: 1,
                current_item: cur_itm}),
        success: function(data)
                {
                    $("#edit_items").html(data);
                }
    });
}

function butt_open1()
{  
    //return 1;//comment this out normally.  auto set if the butt is open
    
    
    //is it proper ordering time
    var date=new Date();
    var day=date.getDay(), hour=date.getHours(), minutes=date.getMinutes();
    
    //between 12am and 12:15am
    if(!hour && minutes<15)
    {
        if(day && day<6)
            return 1;
    }
    //between 10:30pm and 
    else if(hour>22 || (hour==22 && minutes>30))
    {
        if(day<5)
            return 1;
    }
    return 0;
}




//custom alert box from http://www.javascriptsource.com/miscellaneous/custom-alert-box.html
function change_alert()
{

// constants to define the title of the alert and button text.
var ALERT_TITLE = "Pierson Buttery";
var ALERT_BUTTON_TEXT = "Close";

// over-ride the alert method only if this a newer browser.
// Older browser will see standard alerts
if(document.getElementById) {
  window.alert = function(txt) {
    createCustomAlert(txt);
  }
}

function createCustomAlert(txt) {
  // shortcut reference to the document object
  d = document;

  // if the modalContainer object already exists in the DOM, bail out.
  if(d.getElementById("modalContainer")) return;

  // create the modalContainer div as a child of the BODY element
  mObj = d.getElementsByTagName("body")[0].appendChild(d.createElement("div"));
  mObj.id = "modalContainer";
   // make sure its as tall as it needs to be to overlay all the content on the page
  mObj.style.height = document.documentElement.scrollHeight + "px";

  // create the DIV that will be the alert 
  alertObj = mObj.appendChild(d.createElement("div"));
  alertObj.id = "alertBox";
  // MSIE doesnt treat position:fixed correctly, so this compensates for positioning the alert
  if(d.all && !window.opera) alertObj.style.top = document.documentElement.scrollTop + "px";
  // center the alert box
  alertObj.style.left = (d.documentElement.scrollWidth - alertObj.offsetWidth)/2 + "px";

  // create an H1 element as the title bar
  h1 = alertObj.appendChild(d.createElement("h1"));
  h1.appendChild(d.createTextNode(ALERT_TITLE));

  // create a paragraph element to contain the txt argument
  msg = alertObj.appendChild(d.createElement("p"));
  msg.innerHTML = txt;
  
  // create an anchor element to use as the confirmation button.
  btn = alertObj.appendChild(d.createElement("a"));
  btn.id = "closeBtn";
  btn.appendChild(d.createTextNode(ALERT_BUTTON_TEXT));
  btn.href = "#";
  // set up the onclick event to remove the alert when the anchor is clicked
  btn.onclick = function() { removeCustomAlert();return false; }
}

// removes the custom alert from the DOM
function removeCustomAlert() {
  document.getElementsByTagName("body")[0].removeChild(document.getElementById("modalContainer"));
}


}