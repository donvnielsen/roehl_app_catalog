require 'pp'
ln = 'Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "AccountingPortal", "AccountingPortal.csproj", "{9DEA93B2-E905-42FF-AB96-F714B5BC72AF}" '

PARSE_GUID = /[{(]?(?<guid>[0-9A-F]{8}[-]?([0-9A-F]{4}[-]?){3}[0-9A-F]{12})[)}]?/

lhs,rhs = ln.split('=')
pp lhs,rhs

pp PARSE_GUID.match(ln.strip)

slnname,prjfname,prjguid = rhs.split(',')

pp /(?<slnname>\w+)/.match(slnname.strip)
pp /\"((?:[^\/]*\/)*)(\w+\.csproj)\"/.match(prjfname.strip)
pp PARSE_GUID.match(prjguid.strip)


