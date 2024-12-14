Class DataBases.Taks.DataCapture Extends %SYS.Task.Definition
{

/// Database size alarm
Property AlarmSize As %Integer;

/// Atual total increase in alarm volume size
Property IncrementalSize As %Integer;

/// Daily increase in alarm volume size
Property DayActualSize As %Integer;

Method OnTask() As %Status
{
	Set tSC = $$$OK
	// Statistical database size data
	Set tSC = ..Add()
	d ..Init()
	Set util = ##class(DataBases.SYS.Detail).%New()
	// Task execution alert
	Set tSC = util.DayWarning()
	Set tSC = util.ActualWarning()
	Set tSC = util.SizeWarning()
	
	Quit tSC
}

Method Init() As %Status
{
	Set ^DataBaseConfiig("day") = ..DayActualSize
	Set ^DataBaseConfiig("Size") = ..AlarmSize
	Set ^DataBaseConfiig("actual") = ..IncrementalSize
	Quit $$$OK
}

Method Add() As %Status
{
	 
	Set DataArr = ##class(DataBases.SYS.Detail).ListFreeSpace(,$namespace)
	Set iter =DataArr.%GetIterator()
	Set DataBaseTime = $ZDT($Now(),3)
	while iter.%GetNext(.key,.value){
		Set Name = value.Name
		Set Size = value.Size
		Set FreeSize = value.FreeSize
		Set ActualSize = value.ActualSize
		Set Directory = value.Directory
		if $GET(^DataBaseSize(Name))="" Set ^DataBaseSize(Name) = ActualSize
		&SQL(insert into DataBases_DB.Size ( Name, Size,FreeSize, ActualSize,Directory , DataBaseTime )
		values (:Name, :Size,:FreeSize ,:ActualSize , :Directory , :DataBaseTime))
	}
	Quit $$$OK
}

}

