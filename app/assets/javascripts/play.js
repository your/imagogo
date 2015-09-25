function pollIt(id) {
	$('#loader-'+id).show()
	$.poll(function(retry) {
		$.get('/op/'+id+'.json', function(response, status) {
			if (status == 'success') {
				op_type = response["operation_type"];
				op_status = response["status"];
				if (op_type === "resize" && op_status === "ok") {
					$('#loader-'+id).hide();
					$('#img-'+id).show();
				} else
					retry()
			} else
				retry()
		})
	})
}