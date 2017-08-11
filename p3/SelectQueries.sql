-- 1
SELECT snumber, sfullnames, uni.ageinyears(sdateofbirth), sdegreecode
FROM uni.undergraduate
WHERE uni.isregisteredfor(snumber, 'COS326');

-- 2
SELECT uni.hasvalidcoursecodes('COS301,COS326,MTH301'); -- should output true

SELECT uni.hasvalidcoursecodes('COS301,COS326,MTH322'); -- should output false

-- 3
SELECT uni.hasduplicatecoursecodes('COS301,COS326,MTH301'); -- should output false

SELECT uni.hasduplicatecoursecodes('COS301,COS326,MTH301,MTH301'); -- should output true
