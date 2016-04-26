function [priorNonSpam,priorSpam,tokenSpamCondProb,tokenNonSpamCondProb]=trainNaiveBayes(file)

    [spmatrix, tokenlist, trainCategory] = readMatrix(file);

    trainMatrix = full(spmatrix);
    numTrainDocs = size(trainMatrix, 1);
    numTokens = size(trainMatrix, 2);

    % trainMatrix is now a (numTrainDocs x numTokens) matrix.
    % Each row represents a unique document (email).
    % The j-th column of the row $i$ represents the number of times the j-th
    % token appeared in email $i$. 

    % tokenlist is a long string containing the list of all tokens (words).
    % These tokens are easily known by position in the file TOKENS_LIST

    % trainCategory is a (1 x numTrainDocs) vector containing the true 
    % classifications for the documents just read in. The i-th entry gives the 
    % correct class for the i-th email (which corresponds to the i-th row in 
    % the document word matrix).

    % Spam documents are indicated as class 1, and non-spam as class 0.
    % Note that for the SVM, you would want to convert these to +1 and -1.

    %%
    trainCategory=trainCategory';
    priorSpam=sum(trainCategory)/numTrainDocs;
    tokenSpamCount=zeros(1,numTokens);

    for i =1:numTokens;
        tokenSpamCount(i)=dot(trainMatrix(:,i),trainCategory);
    end

    denomSpam=sum(tokenSpamCount)+numTokens;

    tokenSpamCondProb=zeros(1,numTokens);

    for i =1:numTokens;
        tokenSpamCondProb(i)=(tokenSpamCount(i)+1)/denomSpam;
    end

    priorNonSpam=1-priorSpam;

    tokenNonSpamCount=zeros(1,numTokens);

    for i =1:numTokens;
        tokenNonSpamCount(i)=dot(trainMatrix(:,i),1-trainCategory);
    end

    denomNonSpam=sum(tokenNonSpamCount)+numTokens;

    tokenNonSpamCondProb=zeros(1,numTokens);

    for i =1:numTokens;
        tokenNonSpamCondProb(i)=(tokenNonSpamCount(i)+1)/denomNonSpam;
    end