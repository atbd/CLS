function [paramValue res] = getParamValue2(xmlFile, paramName, defaultValue)
%
%   paramValue = getParamValue2(xmlFile, paramName, defaultValue)
%
%   Get the value of the parameter 'paramName' in the file 'xmlFile'. If
%   the tag doesn't exist, the function ask to use the default value. 
%  
%   INPUT :
%   xmlFile		: Parameter file in xml format.
%   paramName	: Parameter name 
%   defaultValue: Default Value
%  
%   OUTPUT:
%   paramValue	: Parameter Value
%	res 		: false if the parameter doesn't exist and the default value 
%				  doesn't be used
%
%   EXAMPLE:
%   vit_max = getParamValue2('Param.xml', 'Vit_max', '2.8')
%   
%   AUTHOR  :   BCA
%   DATE    :   06/2006


[node1 node2] = strtok(paramName, '/');
node2 = node2(2:end); % pour enlever le '/'

paramValue = defaultValue;
res = true;

try
	xDoc = xmlread(xmlFile);

	%nodeName = strcat('parametres/', paramName);
	node1List = xDoc.getElementsByTagName(node1);
	
	if (node1List.getLength < 1)
		res = false;
	else
		for i = 0:node1List.getLength-1
			paramElement = node1List.item(i);
			dataList = paramElement.getElementsByTagName(node2);
			if dataList.getLength > 0
				paramValue = dataList.item(0).getFirstChild.getData;
			end
		end
	end
catch
	res = false;
end

if (res == true); return; end;
	res = true;
	ans = questdlg(['Parameter ''' paramName ''' not found. Do you want to use the default value (' defaultValue ')?']) ;
	if ~strcmp(ans, 'Yes')
		res = false;
		return;
	end
end
