function FnCapitalEquity(lcapital)

if DistributeProfitsInProportion==0
    FnCapitalEquity = (1.0-fundlev)*(lcapital*elast*ra +...
        (1.0-corptax)*tfp*(lcapital^alpha)*(labor^(1.0-alpha))) - Ea*elast*ra ;
end

if DistributeProfitsInProportion
    FnCapitalEquity = (1.0-fundlev)*(lcapital*elast*ra +...
        profdistfrac*(1.0-corptax)*tfp*(lcapital^alpha)*(labor^(1.0-alpha))) - Ea*elast*ra;

end


end