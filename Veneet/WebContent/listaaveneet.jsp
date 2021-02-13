<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Veneet</title>
</head>
<body>
<table id="listaus">
	<thead>
		<tr>
			<th colspan="6" class="oikealle"><span id="uusiVene">Lisää uusi vene</span></th>
		</tr>
		<tr>
			<th class="oikealle">Hakusana:</th>
			<th colspan="4"><input type="text" id="hakusana"></th>
			<th><input type="button" value="Hae" id= "hakunappi"></th>
		</tr>
		<tr>
			<th>Nimi</th>
			<th>Merkki / Malli</th>
			<th>Pituus</th>
			<th>Leveys</th>
			<th>Hinta</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
<script>
$(document).ready(function() {
	
	$("#uusiVene").click(function() {
		document.location="lisaavene.jsp";
	});
	
	haeTiedot();
	$("#hakunappi").click(function() {
		haeTiedot();
	});
	$(document.body).on("keydown", function(event) {
		if(event.which==13) {
			haeTiedot();
		}
	});
	$("#hakusana").focus();
});

function haeTiedot() {
	$("#listaus tbody").empty();
	$.ajax({
		url:"veneet/"+$("#hakusana").val(), 
		type:"GET", 
		dataType:"json", 
		success:function(result) {
			$.each(result.veneet, function(i, field) {
				var htmlStr;
				htmlStr+="<tr id='rivi_"+field.tunnus+"'>";
				htmlStr+="<td>"+field.nimi+"</td>";
				htmlStr+="<td>"+field.merkkimalli+"</td>";
				htmlStr+="<td>"+field.pituus+"</td>";
				htmlStr+="<td>"+field.leveys+"</td>";
				htmlStr+="<td>"+field.hinta+"</td>";
				htmlStr+="<td><a href='muutavene.jsp?tunnus="+field.tunnus+"'>Muuta</a>&nbsp;";
				htmlStr+="<span class='poista' onclick=poista('"+field.tunnus+"')>Poista</span></td>";
				htmlStr+="</tr>";
	        	$("#listaus tbody").append(htmlStr);
			});
	}});
}

function poista(tunnus) {
	if(confirm("Vahvista poisto")) {
		$.ajax({
			url:"veneet/"+tunnus,
			type: "DELETE",
			dataType: "json",
			success:function(result) {
				if(result.response==0) {
					$("#ilmo").html("Veneen poisto epäonnistui.");
				} else if(result.response==1) {
					$("#rivi_"+tunnus).css("background-color", "red");
					alert("Veneen poisto onnistui.");
					haeTiedot();
				}
			}});
	}
}
</script>
</body>
</html>