Class DataBases.SYS.Detail Extends %RegisteredObject
{

/// Daily database incremental alarm
ClassMethod DayWarning()
{
	// Obtain the initial storage time of the day
	Set startTime = ##class(Ens.Util.FunctionSet).ConvertDateTime($zd($now(),3), "%Y-%m-%d","%Y-%m-%d %H:%M:%S")
	&SQL(select top 1 DataBaseTime into :DataBaseTime from DataBases_DB.Size where DataBaseTime >=:startTime )
	// Obtain the actual size of the database
	Set sql = " Select ActualSize, DataBaseTime, Directory, FreeSize, Name, Size from "
			 _" DataBases_DB.Size where DataBaseTime = ? "
	Set tStatment = ##class(%SQL.Statement).%New()
	Set tSC = tStatment.%Prepare(sql)
	Set Rest = tStatment.%Execute(DataBaseTime)
	while Rest.%Next(){
		Set Name = Rest.%Get("Name")
		Set oldActualSize = Rest.%Get("ActualSize")
		Set obj = ..ListFreeSpace(Name,$namespace)
		Set newActualSize = obj.%Get(0).ActualSize
		Set increment = newActualSize - oldActualSize
		if increment > ^DataBaseConfiig("day"){
			Set message = "Today's initial size of database "_Name_" is "_oldActualSize
						_" M , currently "_newActualSize
						_" M , The database has grown by "_increment
						_" M , The growth warning threshold is "_^DataBaseConfiig("day")
			d ..WriteToConsoleLog(message,1)
		}
	}
	quit $$$OK
}

/// Database growth threshold alarm
ClassMethod ActualWarning() As %String
{
	Set Name =""
	for {
		Set Name=$O(^DataBaseSize(Name))  Quit:""=Name
		Set newActualSize =..ListFreeSpace(Name,$namespace).%Get(0).ActualSize
		Set increment = newActualSize - ^DataBaseSize(Name)
		if increment > ^DataBaseConfiig("actual"){
			Set message = "The initial size of database "_Name_" is "_^DataBaseSize(Name)
						_" M , currently "_newActualSize
						_" M , The database has grown by "_increment
						_" M , The growth warning threshold is "_^DataBaseConfiig("actual")
			d ..WriteToConsoleLog(message,1)
		}
	}
	quit $$$OK
}

ClassMethod SizeWarning() As %String
{
	Set Name =""
	for {
		Set Name=$O(^DataBaseSize(Name))  Quit:""=Name
		Set Size =..ListFreeSpace(Name,$namespace).%Get(0).Size
		if Size > ^DataBaseConfiig("Size"){
			Set message = "The current size of the database is "_Size_" M, exceeding the set threshold of "
						_^DataBaseConfiig("Size")_" M. Please check the disk space carefully"
			d ..WriteToConsoleLog(message,1)
		}
	}
	quit $$$OK
}

///  Write a message to the messages.log file.
///  Severity = -2 (Debug2), -1 (Debug), 0 (Information), 1 (Warning), 2 (Severe), 3 (Fatal)
ClassMethod WriteToConsoleLog(Message As %String, Severity As %Integer = 1)
{
	Set tSC = ##class(%SYS.System).WriteToConsoleLog(Message,0,Severity,"Database.Size")
	Quit tSC
}

ClassMethod DBList() As %DynamicArray
{
	Set NameSpace =$namespace
	new $namespace
	Set $namespace = "%SYS"
	Set dynamicArray =[]
	Set Rset=##class(%ResultSet).%New("SYS.Database:FreeSpace")
	if 'Rset {Quit $$$NO}
	Set r=Rset.Execute("*")
	if r {
	 	While (Rset.Next()) {
		  	DO dynamicArray.%Push(Rset.Data("DatabaseName"))
	 	}
	 	Do Rset.Close()
	}
	
	
	new $namespace
	Set $namespace = NameSpace
	Quit dynamicArray
}

ClassMethod ListFreeSpace(Name As %String = "", NameSpace As %String) As %DynamicArray
{
	new $namespace
	Set $namespace = "%SYS"
	Set:$L(Name)=0 Name="*"
	Set pOutput = ##class(%DynamicObject).%New()
	Set dynamicArray = ##class(%DynamicArray).%New()
	Set Rset=##class(%ResultSet).%New("SYS.Database:FreeSpace")
	if 'Rset {Quit $$$NO}
	Set r=Rset.Execute(Name)
	if r {
	 	While (Rset.Next()) {
	  		Set dynamicObj = ##class(%DynamicObject).%New()
	  		Do dynamicObj.%Set("Name",Rset.Data("DatabaseName"))
	  		Do dynamicObj.%Set("Directory",Rset.Data("Directory"))
	  		Do dynamicObj.%Set("Size",Rset.Data("SizeInt"))
	  		Do dynamicObj.%Set("FreeSize",Rset.Data("AvailableNum"))
	  		Do dynamicObj.%Set("ActualSize",Rset.Data("SizeInt")- Rset.Data("AvailableNum"))
		  	DO dynamicArray.%Push(dynamicObj)
	 	}
	 	Do Rset.Close()
	}
	new $namespace
	Set $namespace = NameSpace
	Quit dynamicArray
}

}

