function error=testNaiveBayes(priorNonSpam,priorSpam,tokenSpamCondProb,tokenNonSpamCondProb)

[spmatrix, tokenlist, category] = readMatrix('MATRIX.TEST');

testMatrix = full(spmatrix);
numTestDocs = size(testMatrix, 1);
numTokens = size(testMatrix, 2);

output = zeros(numTestDocs, 1);

for j=1:numTestDocs;
    
    scoreSpam=log(priorSpam);
    scoreNonSpam=log(priorNonSpam);

    for i=1:numTokens;
        scoreSpam = scoreSpam + testMatrix(j,i)*log(tokenSpamCondProb(i));
        scoreNonSpam = scoreNonSpam + testMatrix(j,i)*log(tokenNonSpamCondProb(i));
    end
    output(j)=(scoreSpam>scoreNonSpam)*1;
end

% Compute the error on the test set
error=0;
for i=1:numTestDocs
  if (category(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
error=error/numTestDocs