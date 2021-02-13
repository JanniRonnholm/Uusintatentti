<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta veneen tietoja</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>
			<tr>
				<th colspan="6" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
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
			<tr>
				<td><input type="text" name="nimi" id="nimi"></td>
				<td><input type="text" name="merkkimalli" id="merkkimalli"></td>
				<td><input type="text" name="pituus" id="pituus"></td>
				<td><input type="text" name="leveys" id="leveys"></td>
				<td><input type="text" name="hinta" id="hinta"></td>
				<td><input type="submit" id="tallenna" value="Muuta"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="tunnus" id="tunnus">
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function() {
	
	$("#takaisin").click(function() {
		document.location="listaaveneet.jsp";
	});
	
	var tunnus = requestURLParam("tunnus");
	$.ajax({
		url:"veneet/haeyksi/"+tunnus,
		type:"GET",
		dataType:"json",
		success:function(result){
			$("#nimi").val(result.nimi);
			$("#merkkimalli").val(result.merkkimalli);
			$("#pituus").val(result.pituus);
			$("#leveys").val(result.leveys);
			$("#hinta").val(result.hinta);
		}});
	
	$("#tiedot").validate({
		rules: {
			nimi: {
				required: true,
				minlength: 3
			},
			merkkimalli: {
				required: true,
				minlength: 3
			},
			pituus: {
				required: true,
				number: true,
				minlength: 1,
				maxlength: 5
			},
			leveys: {
				required: true,
				number: true,
				minlength: 1,
				maxlength: 5
			},
			hinta: {
				required: true,
				number: true,
				minlength: 3,
				maxlength: 6
			}
		},
		messages: {
			nimi: {
				required: "Nimi on pakollinen tieto",
				minlength: "Sy�tt�m�si arvo on liian lyhyt"
			},
			merkkimalli: {
				required: "Merkki / malli on pakollinen tieto",
				minlength: "Sy�tt�m�si arvo on liian lyhyt"
			},
			pituus: {
				required: "Pituus on pakollinen tieto",
				number: "Sy�t� arvo numeraalisessa muodossa",
				minlength: "Sy�tt�m�si arvo on liian pieni",
				maxlength: "Sy�tt�m�si arvo on liian suuri"
			},
			leveys: {
				required: "Leveys on pakollinen tieto",
				number: "Sy�t� arvo numeraalisessa muodossa",
				minlength: "Sy�tt�m�si arvo on liian pieni",
				maxlength: "Sy�tt�m�si arvo on liian suuri"
			},
			hinta: {
				required: "Hinta on pakollinen tieto",
				number: "Sy�t� arvo numeraalisessa muodossa",
				minlength: "Sy�tt�m�si arvo on liian pieni",
				maxlength: "Sy�tt�m�si arvo on liian suuri"
			}
		},
		submitHandler: function(form) {
			paivitaTiedot();
		}
	});
	$("#nimi").focus();
});

function paivitaTiedot() {
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); 
	$.ajax({
		url:"veneet", 
		data:formJsonStr, 
		type:"PUT", 
		dataType:"json", 
		success:function(result){        
			if(result.response==0){
        		$("#ilmo").html("Veneen p�ivitt�minen ep�onnistui.");
        	}else if(result.response==1){			
        		$("#ilmo").html("Veneen p�ivitt�minen onnistui.");
        		$("#nimi", "#merkkimalli", "#pituus", "#leveys", "#hinta").val("");
		}
    }});	
}
</script>
</html>