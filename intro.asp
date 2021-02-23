<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include virtual="include/dbconnection.asp"-->  
<%
	response.Buffer = true   
	session.CodePage = 65001   
	response.Charset = "utf-8"

	sql="select count(indx) as c from member where customer_id=411"
	set rs=connection2.execute(sql)
	if not rs.eof then
		num=rs("c")
	end if
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>vocabulary 單字庫</title>
		<link href="./css/main.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/506022d22e.js"></script>
		<script src="./assets/plugins/vue/vue2.6.12.js"></script>
		<script src="./assets/plugins/jquery/jquery.1.12.4.min.js"></script>
	</head>
	<body>
		<div class="vhead" onclick="window.history.back()">
			<h1><i class="fas fa-chevron-left"></i>單字庫</h1>
		</div>
		<div class="vbody" id="app">
			<div class="vbox">
				<div class="vbox-box"
					v-for='(block, i) in filterList'
					:key='i'
				>
					<div class="vbox-title">{{block.key}}</div>
					<div class="vbox-list">
						<div class="vbox-item"
							v-for='(item, j) in block.ary'
							:key='j'
						>
							<div class="vbox-voc">{{item.En_word}}</div>
							<div class="vbox-memo" >
								<div class="mbox-txt"
									v-if="item.id != editing.id"
									@click="fnEdit(item.id, item.Ch_word)"
								>{{item.Ch_word}}</div>
								<div v-else >
									<textarea class="mbox-textarea"
										v-model='editing.txt'
									></textarea>
									<div class="mbox-editbox">
										<i class="fas fa-check mbox-update"
											@click='fnUpdate(item.En_word, editing.txt, i, j)'
										></i>
										<i class="fas fa-trash-alt mbox-delete"
											@click="fnDelete(item.En_word, i, j)"
										></i>
										<i class="fas fa-times mbox-cancle"
											@click='editing={id: "", txt: ""}'
										></i>
									</div>
								</div>
							</div>
						</div><!--vbox-item-->
					</div><!--vbox-list-->
				</div>
			</div>
		</div>
	</body>
	<script>
		const member_id = 227332;
		const App = new Vue({
			created(){
				const vm = this;
				$.ajax({
					url: '../api/WordCard?member_id=' + member_id + '&customer_id=411',
					type: 'GET',
					contentType: 'application/json',
					success(res){
						res.data.forEach(function(ary, i){
							const key = ary[0].En_word.split('')[0].toLowerCase();
							ary.forEach(function(item, i){
								if( item.Ch_word == "" ){ item.Ch_word = "(no memo)"}
								item.id = key + '-' + i;
							});
							const obj = {key, ary};
							vm.list.push(obj);
						});
					}
				});
			},
			computed: {
				filterList(id){ return this.list }
			},
			methods: {
				fnEdit(id, ch){
					const vm = this;
					vm.editing.id = id;
					vm.editing.txt = ch;
				},

				fnUpdate(en, ch, i, j){
					const vm = this;
					$.ajax({
						url: "../U/api/vocabulary/join?member_id=" + member_id + "&customer_id=411&Enkeyword=" + en + "&Chkeyword=" + ch,
						type: 'post',
						contentType: 'application/json',
						success(res){
							vm.list[i].ary[j].Ch_word = vm.editing.txt;
							vm.editing = {id: '', txt: ''};
						}
					})
				},

				fnDelete(en, i, j){
					const vm = this;
					const check = confirm('確定要刪除「' + en + ' 單字及筆記」嗎?\n**確認刪除後將無法回朔');
					if(check){
						$.ajax({
							url: "../D/api/vocabulary/join?member_id=" + member_id + "&customer_id=411&Enkeyword=" + en,
							type: 'POST',
							contentType: 'application/json',
							success(res){
								vm.list[i].ary.splice(j, 1);
								if( vm.list[i].ary.length == 0 ){ vm.list.splice(i, 1) };
								vm.editing = {id: '', txt: ''};
							}
						})
					}else{
						vm.editing = {id: '', txt: ''};
					}
				}
			},
			data: {
				list: new Array(),
				editing: {id: '', txt: ''}
			},
		  el: '#app'
		});
	</script>
</html>