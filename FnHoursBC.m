function FnHoursBC(lh)

if LaborSupplySep
	if ScaleDisutilityIdio==0
        FnHoursBC = chi*(lh^(1.0/frisch)) - utilfn1(gbdrift + lh*gnetwage) * gnetwage;
  end
	if ScaleDisutilityIdio 
        FnHoursBC = chi*(lh^(1.0/frisch)) - utilfn1(gbdrift + lh*gnetwage) * (gnetwage/gidioprod);
  end    
end


end