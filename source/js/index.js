$(()=>{
	$('.mbox-input').click(function(){
		const type = $(this).attr('data-edit');
		console.log(type);
		
		if(type=='false'){
			$('.mbox-input').attr('contenteditable', 'false').attr('data-edit', 'false');
			$(this).attr('contenteditable', 'true').focus().attr('data-edit', 'true');

		}
	})
});