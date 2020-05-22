<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Listaa veneet</title>
</head>
<body onkeydown="tutkiKey(event)">
	<span id="ilmo"></span>
	<table id="listaus">
		<thead>	
			<tr>
				<th colspan="6" class="oikealle"><a id="uusiVene" href="lisaavene.jsp">Lis‰‰ uusi vene</a></th>
			</tr>
			<tr>
				<th colspan="4" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae" onclick="haeTiedot()"></th>
			</tr>		
			<tr>
				<th>Nimi</th>
				<th>Merkkimalli</th>
				<th>Pituus</th>
				<th>Leveys</th>
				<th>Hinta</th>
				<th></th>	
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
<script>
	
haeTiedot();	
document.getElementById("hakusana").focus();

function tutkiKey(event){
	if(event.keyCode==13){
		haeTiedot();
	}		
}

function haeTiedot(){	
	document.getElementById("tbody").innerHTML = "";
	fetch("veneet/" + document.getElementById("hakusana").value,{
	      method: 'GET'	      
	    })
	.then( function (response) {
		return response.json()
	})
	.then( function (responseJson) {
		var veneet = responseJson.veneet;	
		console.log(veneet);
		var htmlStr="";
		for(var i=0;i<veneet.length;i++){			
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+veneet[i].nimi+"</td>";
        	htmlStr+="<td>"+veneet[i].merkkimalli+"</td>";
        	htmlStr+="<td>"+veneet[i].pituus+"</td>";
        	htmlStr+="<td>"+veneet[i].leveys+"</td>";
        	htmlStr+="<td>"+veneet[i].hinta+"</td>";  
        	htmlStr+="<td><a href='muutavene.jsp?tunnus="+veneet[i].tunnus+"'>Muuta</a>&nbsp;";
        	htmlStr+="<span class='poista' onclick=poista("+veneet[i].tunnus+",'"+veneet[i].nimi+"')>Poista</span></td>";
        	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;		
	})	
}

function poista(tunnus, nimi){
	if(confirm("Poista vene " + nimi + "?")){	
		fetch("veneet/" + tunnus,{
		      method: 'DELETE'	      
		    })
		.then( function (response) {
			return response.json()
		})
		.then( function (responseJson) {
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Veneen poisto ep‰onnistui.";
	        }else if(vastaus==1){	        	
	        	alert("Veneen " + nimi +" poisto onnistui.");
				haeTiedot();        	
			}	
		})		
	}	
}
</script>
</body>
</html>