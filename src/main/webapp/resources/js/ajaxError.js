console.log("ajax error script ready");

$.ajaxSetup({
    	error: function(jqXHR, exception) {
        	if (jqXHR.status === 0) {
            	alert('Not connect.\n Verify Network.');
        	}
        	else if (jqXHR.status == 400) {
            	alert('Server understood the request, but request content was invalid. [400]');
        	}
        	else if (jqXHR.status == 401) {
            	alert('Unauthorized access. [401]');
        	}
        	else if (jqXHR.status == 403) {
            	alert('Forbidden resource can not be accessed. [403]');
        	}
        	else if (jqXHR.status == 404) {
            	alert('Requested page not found. [404]');
        	}
        	else if (jqXHR.status == 500) {
            	alert('Internal server error. [500]');
        	}
        	else if (jqXHR.status == 503) {
            	alert('Service unavailable. [503]');
        	}
        	else if (exception === 'parsererror') {
            	alert('Requested JSON parse failed. [Failed]');
        	}
        	else if (exception === 'timeout') {
            	alert('Time out error. [Timeout]');
        	}
        	else if (exception === 'abort') {
            	alert('Ajax request aborted. [Aborted]');
        	}
        	else {
            	alert('Uncaught Error.n' + jqXHR.responseText);
        	}
    	}
	});