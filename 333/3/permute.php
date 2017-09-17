<?php

	global $argv;
	$arr = array();

	for ($k = 1; $k < count($argv); $k++)
		array_push($arr, $argv[$k]);

	$permuted = false;
	$perm = array();

	function generatePermutations($arr) {
		$out = array();
		$permuted = true;

		recursion($arr, $out);
		modifyPermutations($perm);

		for ($k = 0; $k < count($perm); $k++) {
			for ($j = 0; $j < count($perm[$k]); $j++) {
				if ($j > 0)
					echo " ";
				echo $perm[$k][$j];
			}
			echo "<br>";
		}
	}

	function recursion($arr, $out) {
		if (count($arr) == 1) {
			$newOut = array();
			for ($k = 0; $k < count($out); $k++)
				array_push($newOut, $out[$k]);
			array_push($newOut, $arr[0]);

			array_push($perm, $newOut)
			return;
		}

		for ($k = 0; $k < count($arr); $k++) {
			$newArr = array();

			for ($j = 0; $j < count($arr); $j++) {
				if ($j != $k)
					array_push($newArr, $arr[$j]);
			}

			$newOut = array();
			for ($j = 0; $j < count($out); $j++)
				array_push($newOut, $out[$j]);
			array_push($newOut, $arr[$k]);

			recursion($newArr, $newOut);
		}
	}

	function modifyPermutations($arr) {
		for ($k = 0; $k < count($arr); $k++)
			for ($j = 0; $j < count($arr[$k]); $j++)
				$arr[$k][$j] = $arr[$k][$j] * $arr[$k][$j];
	}

?>
