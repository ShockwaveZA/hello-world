-- 1
SELECT snumber, ufullnames, uni.ageinyears(udateofbirth), udegreecode
FROM uni.undergraduate
WHERE uni.isregisteredfor(snumber, 'COS326');
