Class DataBases.DB.Size Extends %Persistent
{

Index Name On Name;

Index DataBaseTime On DataBaseTime;

Property Name As %String;

Property Size As %String;

Property FreeSize As %String;

Property ActualSize As %String;

Property Directory As %String;

Property DataBaseTime As %String;

Storage Default
{
<Data name="SizeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Size</Value>
</Value>
<Value name="4">
<Value>DataBaseTime</Value>
</Value>
<Value name="5">
<Value>Directory</Value>
</Value>
<Value name="6">
<Value>FreeSize</Value>
</Value>
<Value name="7">
<Value>ActualSize</Value>
</Value>
</Data>
<DataLocation>^DataBases.DB.SizeD</DataLocation>
<DefaultData>SizeDefaultData</DefaultData>
<IdLocation>^DataBases.DB.SizeD</IdLocation>
<IndexLocation>^DataBases.DB.SizeI</IndexLocation>
<StreamLocation>^DataBases.DB.SizeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

