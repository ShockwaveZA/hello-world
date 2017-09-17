import sys
import os
import pickle

def generatePermutations(arr=[1, 2, 3]):
	out = []
	return permute(arr, out)

def permute(arr, out):
	if (len(arr) == 1):
		newOut = []
		newOut.extend(out)
		newOut.extend(arr)
		return newOut
	ret = []
	for k in range(0, len(arr)):
		newArr = [];
		for j in range(0, len(arr)):
			if (j != k):
				newArr.append(arr[j])
		newOut = [];
		newOut.extend(out)
		newOut.append(arr[k])
		ret.extend(permute(newArr, newOut))
	return ret

def modifyPermutations(arr):
	for k in range(0, len(arr)):
		arr[k] = arr[k] ** 2
	return arr

def picklePermutations(perms, fname = 'permutations.pkl'):
	with open(fname, 'wb') as f:
		pickle.dump(perms, f)


def getPickledPermutations(fname = 'permutations.pkl'):
	with open(fname, 'rb') as f:
		return pickle.load(f)

def printList(arr, length):
	count = 0
	for k in range(0, len(arr)):
		if (count < length - 1):
			print (arr[k], ' ', end='')
			count += 1
		else:
			print (arr[k])
			count = 0

args = []
for k in range(1, len(sys.argv)):
	args.append(int(sys.argv[k]))
	
yn = input('Read previous permutations? (y/n): ')
if (yn == 'y'):
	perms = []
	fname = input('file name: ')
	l = int(input('length: '))
	if (fname == ''):
		perms = getPickledPermutations()
	else:
		perms = getPickledPermutations(fname)
	printList(modifyPermutations(perms), l)
else:
	perms = []
	if (args == []):
		perms = generatePermutations()
		printList(perms, 3)
	else:
		perms = generatePermutations(args)
		printList(perms, len(args))
picklePermutations(perms)
