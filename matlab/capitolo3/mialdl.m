function x = mialdl(A, b)
    % Syntax: x = mialdl(A, b)
    % Method of the secant, used to calculate a root of the equation f(x)=0
    % Input:  A     - a matrix rapresentation of the equations with unknown variables
    %                 It is assumed that A is symmetric and postive definite.
    %         b     - result of unknown variables
    % Output: x     - array of unknown variables

    try
        % Checking if matrix is SPD with "if" is not most efficient way.
        % But still can be used by next syntax:
        % `~issymmetric(A) || ~all(eig(A) > 0)`
        % According to
        % [this](https://www.mathworks.com/help/matlab/math/determine-whether-matrix-is-positive-definite.html)
        % article most efficient way is to use Cholesky Factorization.
        chol(A);
    catch
        error('The matrix provided is not symmetric and postive definite!')
    end

    % Figure out the size of A.
    n = size(A, 1);
    % The main loop.  See Golub and Van Loan for details.
    L = zeros(n, n);
    v = zeros(1, n);
    d = zeros(1, n);

    for j = 1:n

        if (j > 1)
            v(1:j - 1) = L(j, 1:j - 1) .* d(1:j - 1);
            v(j) = A(j, j) - L(j, 1:j - 1) * v(1:j - 1)';
            d(j) = v(j);

            if (j < n)
                L(j + 1:n, j) = (A(j + 1:n, j) - L(j + 1:n, 1:j - 1) * v(1:j - 1)') / v(j);
            end

        else
            v(1) = A(1, 1);
            d(1) = v(1);
            L(2:n, 1) = A(2:n, 1) / v(1);
        end

    end

    %  Put d into a matrix.
    D = diag(d);
    %  Put ones on the diagonal of L.
    L = L + eye(n);
    U = D * L';
    x = zeros(n, 1);
    y = zeros(n, 1);

    % calculate answers for Ly = b
    for i = 1:1:n
        alpha = 0;

        for k = 1:1:i
            alpha = alpha + L(i, k) * y(k);
        end

        y(i) = b(i) - alpha;
    end

    % calculate answers for Ux = y
    for i = n:-1:1
        alpha = 0;

        for k = i + 1:1:n
            alpha = alpha + U(i, k) * x(k);
        end

        x(i) = (y(i) - alpha) / U(i, i);
    end

end
