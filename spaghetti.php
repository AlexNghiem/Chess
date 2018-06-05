<?php
	
	$s = 'pypy3 ./depthSearch.py ' . $_GET['pieces'] . ' ' . $_GET['castleWhiteQueenside'] . ' ' . $_GET['castleWhiteKingside'] . ' ' . $_GET['castleBlackQueenside'] . ' ' . $_GET['castleBlackKingside'];
	//echo($s);
	//echo("\n");
	$raw = exec($s); 
	//echo($_GET['castleWhiteQueenside'] . " Hi");
	echo($raw);
?>
