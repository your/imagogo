function pollIt(id) {
	$('#loader-'+id).show()
	$.poll(function(retry) {
		$.get('/op/'+id, function(response, status) {
			if (status == 'success') {
				$('#loader-'+id).hide();
				$('#img-'+id).show();
			} else
				retry()
		})
	})
}