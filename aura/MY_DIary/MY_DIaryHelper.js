({
    loadCalendar: function(comp) {
        var toastEventOnUnavailableAssignments = $A.get("e.force:showToast"); //Prepare toast event instance                     
        var record=comp.get("v.recordId");
        console.log('Record ID'+record);
        //Prepare data for calendar
        console.log('Engineer User ID'+$A.get("$SObjectType.CurrentUser.Id"));
        var action = comp.get("c.getAssignmentsByUser"); //Get assignments by user id
        action.setParams({"userId":$A.get("$SObjectType.CurrentUser.Id")});
        var assignments=[];
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                assignments = response.getReturnValue();               
                //var assignments= this.formatAssignments(component,assignmentsdata);                
                var josnDataArray = [];
                var newStart;
                var newEnd;
                var custName;
                //console.log("Assignments=="+assignments.length);
                for (var i = 0; i < assignments.length; i++) {                                
                    //Convert GMT time value to user's local timezone                                                                                   
                    newStart=new Date(assignments[i].start_datetime__c);                            
                    newEnd=new Date(assignments[i].End_DateTime__c);
                     //custName=assignments[i].Site__r.name,
                    josnDataArray.push({
                        'id': assignments[i].id,
                        'title':assignments[i].Name,
                        'job_no':assignments[i].Name,
                        'site_name':assignments[i].Site__c,
                        'cust_names':assignments[i].Site_Name__c,
                        'message':($A.util.isEmpty(assignments[i].Message_to_Technician__c)?'No Msg':assignments[i].Message_to_Technician__c),
                        'start': newStart.toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")}),                
                        'end': newEnd.toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")}),
                        'resourceId': assignments[i].Engineer2__c,                                
                        'allDay': false,
                        'color': assignments[i].Gantt_color__c,
                        'textColor':'black',
                        'url':'/lightning/r/Visits__c/',
                        'job_id':assignments[i].id,
                        'assignment_id':assignments[i].Id,
                        'description':($A.util.isEmpty(assignments[i].Message_to_Technician__c)?'No Msg':assignments[i].Message_to_Technician__c)
                    });                            
                    
                }
                comp.set("v.selectedEngAssignments", josnDataArray); 
                console.log("Result="+JSON.stringify(response.getReturnValue()));
                //this.loadEngCalData(component);                                                         
            }else if (state === "ERROR") {                                                
                console.log("Error logged "+JSON.stringify(response.getError()));
                var errors=response.getError();
                var err_message='Undefined Error. Please contact your administrator';
                if (errors.length > 0) {
                    var err_message = errors[0].message;
                    //err_message=page_err[0].message;
                    
                }
              
                //Show Error message on the screen                        
                toastEventOnUnavailableAssignments.setParams({
                    title : 'ERROR',
                    message: err_message,
                    duration:' 5000',
                    key: 'error_alt',
                    type: 'error',
                    mode: 'dismissible'
                }); 	
                toastEventOnUnavailableAssignments.fire();
            }
        });
        
        $A.enqueueAction(action);  
        
         
        //Get selected engineer's unavailability to add into the event list
        var toastEventOnUnavailability = $A.get("e.force:showToast"); //Prepare toast event instance 
      //  var action = comp.get("c.getUnavailabilityByUser"); 
        var action = comp.get("c.getAssignmentsByUser"); //Get assignments by user id  
        action.setParams({"userId" : $A.get("$SObjectType.CurrentUser.Id")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                                                		
                var responseData = response.getReturnValue();   
                console.log('resourceEvents='+responseData);
                //var assignments= this.formatAssignments(component,assignmentsdata);                
                var calendarEvents= comp.get("v.selectedEngAssignments");			//Pushing the existing assignments into the new list variable
                console.log('calendarEvents='+JSON.stringify(calendarEvents));
                var newStart;
                var newEnd;
                for (var i = 0; i < responseData.length; i++) {  
                    newStart=new Date(responseData[i].Start_datetime__c);                            
                    newEnd=new Date(responseData[i].end_datetime__c);
                    calendarEvents.push({
                        'title': responseData[i].fax__Type__c,
                        'start': newStart.toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")}),                //Convert GMT time value to user's local timezone                
                        'end': newEnd.toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")}),                //Convert GMT time value to user's local timezone  
                     //   'resourceId': responseData[i].fax__Service_Engineer__c,                                
                        'allDay': true, 
                        'color':'gray',
                        'textColor':'black',
                        'editable':false,                                
                        'startEditable':false,
                        'durationEditable':false,
                        'resourceEditable':false,
                        'url':'/lightning/r/fax__Engineer_Unavailable_Period__c/',
                        'job_id':responseData[i].Id,	//Using job_id field for unavailability record id as this was refered in event click to open the event record
                        //'overlap':responseData[i].fax__Allow_Assignments__c
                     //   'description':assignments[i].Message_to_Technician__c
                    });                            
                    
                }                                                                       
                comp.set("v.selectedEngAssignments", calendarEvents);	
                //Loading calendar for the selected engineer on click
                //console.log('Engineer Assignmentss'+JSON.stringify(comp.get("v.selectedEngAssignments")));                                
                $('#eng_calendar').fullCalendar({                                    
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'agendaDay,agendaWeek,month'
                    },
                    schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
                    contentHeight: 'auto',
                    columnFormat:'ddd',
                    weekNumbers: true,
                    weekNumberTitle:'Week',
                    editable: false,
                    theme:true,
                    themeSystem: 'bootstrap3',
                    themeName: 'peper',
                    minTime: '09:00',
                    maxTime: '15:00',
                    buttonText: {
                        SchedulerWeekTimeLine: 'Week',
                        timelineDay: 'Daily',
                        today:'TODAY'
                    },
                     
                    views: {
                        SchedulerWeekTimeLine: {
                            type: 'timeline',
                            duration: { days: 5 }
                        },
                        agendaWeek: {
                            buttonText: 'WEEK'
                        },
                        agendaDay: {
                            buttonText: 'DAY'
                        },
                        month: {
                            buttonText: 'MONTH'
                        }
                    },
                    eventClick: function(event) { 
                        var device = $A.get("$Browser.formFactor");
                        if(device=='DESKTOP'){
                        	if (event.url) {                        
                                window.open(event.url+event.assignment_id+'/view','_blank');                                                           
                            }                                
                        }else{
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": event.url+event.assignment_id+'/view'
                            });
                            urlEvent.fire();
                        }
                        
                        return false;
                    },
                    /*
                    eventMouseEnter: function(event, jsEvent, view) { 
                        $('.fc-event-inner', this).append('<div id=\"'+event.id+'\" class=\"hover-end\">'+'test'+'</div>');
                    },
                    eventMouseout: function(event, jsEvent, view) {
                        $('#'+event.id).remove();
                    },*/
                    eventMouseover: function(event, jsEvent) {
                        var tooltip = '<div class="tooltipevent" style="width:205px;height:auto;background:#ccc;position:absolute;z-index:10001;word-wrap: break-word;">' + event.description + '</div>';
                        var $tooltip = $(tooltip).appendTo('body');
                    
                        $(this).mouseover(function(e) {
                            $(this).css('z-index', 10000);
                            $tooltip.fadeIn('500');
                            $tooltip.fadeTo('10', 1.9);
                        }).mousemove(function(e) {
                            $tooltip.css('top', e.pageY + 10);
                            $tooltip.css('left', e.pageX + 20);
                        });
                    },
                    eventMouseout: function(event, jsEvent) {
                        $(this).css('z-index', 8);
                        $('.tooltipevent').remove();
                    },
                    eventRender: function(event, element) {                 
                        element.css({"height":"auto"});  
                        element.css("font-size", "0.8em"); 
                        element.find('.fc-title').append(" " + event.cust_names+"<br/> "+event.message);
                    },
                    
                    navLinks: true, // can click day/week names to navigate views
                    eventLimit: true, // allow "more" link when to                         
                    disableDragging: false,
                    defaultView: "agendaDay" ,
                    events: comp.get("v.selectedEngAssignments")                        
                });                         
                
            }else if (state === "ERROR") {                                                
                var errors=response.getError();
                var err_message='Undefined Error. Please contact your administrator';
                if (errors.length > 0) {
                    var err_message = errors[0].message;
                    //err_message=page_err[0].message;
                    
                }

                console.log("Error successfully logged "+err_message);
                //Show Error message on the screen                        
                toastEventOnUnavailability.setParams({
                    title : 'ERROR',
                    message: err_message,
                    duration:' 5000',
                    key: 'error_alt',
                    type: 'error',
                    mode: 'dismissible'
                });	         
                toastEventOnUnavailability.fire();
            }
        });
        $A.enqueueAction(action);            
	},
    
    
    //Load MyDiary permissions and other settings
    loadMyDiarySettings: function(component) {
        
        var action = component.get("c.getDispatchBoardSettings");
        
        //Initiate toastEvent instance for alerts and errors on the page
        var toastEvent = $A.get("e.force:showToast");         
        toastEvent.setParams({
            title : 'ERROR',
            message: 'Dispatch Board settings are not loaded. Please refresh. If you still have issues please contact your administrator', //Set default error if the error unknown
            duration:' 5000',
            key: 'error_alt',
            type: 'error',
            mode: 'dismissible'
        });
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var settings = response.getReturnValue();                                                
                component.set("v.DIARY_SETTINGS", settings);
                //console.log("Returned DB Settings="+JSON.stringify(component.get("v.DB_SETTINGS")["DB_Permissions"].fax__DB_Start_Time__c));
                //console.log("Returned Settings="+JSON.stringify(settings));
                  
            } else if (state === "ERROR") {
                var errors=response.getError();
                var err_message='Unknown Error. Please contact your administrator';                        
                if (errors.length > 0 && "pageErrors" in errors[0]) {                                                                                 
                    var page_err = errors[0].pageErrors;
                    if(page_err.length>0){
                        err_message=page_err[0].message;                                            
                    }                            
                }else if(errors.length > 0 && "message" in errors[0]){                           
                    err_message=errors[0].message;                            
                } 
                console.error("Error logged "+JSON.stringify(errors));
                toastEvent.setParams({
                    message:err_message	//Update the message with actual error
                });
                toastEvent.fire(); 
            }
        });
        
        $A.enqueueAction(action);
  
	},
});