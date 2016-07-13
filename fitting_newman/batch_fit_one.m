function batch_fit_one()
    [L(1), U(1), errs(1,:)] = fit_one('coauthor');
    [L(2), U(2), errs(2,:)] = fit_one('dblp');
    [L(3), U(3), errs(3,:)] = fit_one('coauthor_network');
    [L(4), U(4), errs(4,:)] = fit_one('dblp_network');
    [L(5), U(5), errs(5,:)] = fit_one('aps');
    [L(6), U(6), errs(6,:)] = fit_one('patent');
    [L(7), U(7), errs(7,:)] = fit_one('facebook');
    [L(8), U(8), errs(8,:)] = fit_one('twitter');
    [L(9), U(9), errs(9,:)] = fit_one('rome');
    [L(10), U(10), errs(10,:)] = fit_one('beijing');
    [L(11), U(11), errs(11,:)] = fit_one('sf');

    dlmwrite('err.txt', errs, 'delimiter', '\t');

    [L(12), U(12)] = fit_one('sim', 100000, 1, 1, 100);
    [L(13), U(13)] = fit_one('sim', 100000, 1, 100000, 100);
    [L(14), U(14)] = fit_one('sim', 100000, 2, 8, 100);
    [L(15), U(15)] = fit_one('sim', 100000, 3, 10, 100);
    [L(16), U(16)] = fit_one('sim', 100000, 3, 100000, 100);

    dlmwrite('LU.dat', [L', U'], 'delimiter', '\t');

end