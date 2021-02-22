const cpn_item = {
	props: ['prop'],
	template: `
		<div class="vbox-item">
			<div class="vbox-voc">{{prop.En_word}}</div>
			<div class="vbox-memo">
				<div class="mbox-input"
					:contenteditable="edit"
					:data-edit="edit"
					@dblclick="emit_click"
				>{{prop.Ch_word}}</div>
				<div class="mbox-editbox">
					<i class="fas fa-check mbox-update"></i>
					<i class="fas fa-trash-alt mbox-delete"></i>
					<i class="fas fa-times mbox-cancle"></i>
				</div>
			</div>
		</div>
	`,
	methods: {
		emit_click(){
			const vm = this;
			vm.$emit('content_click');
			//
			// if( vm.edit ){
				
			// }else{
			// 	$('.mbox-input').attr('contenteditable', 'false');

			// }
			vm.edit = !vm.edit;
		},
		fnEdit(en, ch){
			$(this).addClass('eason')
			console.log('here', en, '/', ch )
			console.log( $(this), $(this)[0]['data-edit'] );
			// $(this).attr('data-edit', 'true');
		}
	},
	data(){
		return {
			edit: false,
		}
	}
}

const cpn_box = {
	props: ['prop'],
	template: `
		<div class="vbox-box">
			<div class="vbox-title">{{prop.key}}</div>
			<div class="vbox-list">
				<cpn_item
					v-for="(item, i) in prop.ary"
					:prop="item"
					:key="i"
					@content_click='emit_click2'
				></cpn_item>
			</div>
		</div>
	`,
	methods: {
		emit_click2(){
			console.log('emit_click2 work');
			this.$emit('content_click2');
		}
	},
	components: {
		cpn_item
	}
};

