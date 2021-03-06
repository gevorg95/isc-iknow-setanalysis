Class Demo.Utils
{

ClassMethod LoadFromJSON(pJSON As %Stream.Object, pClassName As %String, pUTF8 As %Boolean = 0) As %Status
{
	set tSC = $$$OK
	try {
		set tString=""
		do pJSON.Rewind()
		while 'pJSON.AtEnd {
			set tLine = pJSON.ReadLine()
			set:pUTF8 tLine = $zconvert(tLine,"I","UTF8")
			set tString = tString_tLine
		}
		
		set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(tString,, .tObject)
		quit:$$$ISERR(tSC)
		
		if $$$defClassDefined(pClassName) {
			set tSC = $classmethod(pClassName, "%KillExtent")
			quit:$$$ISERR(tSC)
			
			kill tCols
			for i = 1:1:tObject.columns.Count() {
				set tCol = tObject.columns.GetAt(i)	
				set tCols(tCol.id) = $zstrip(tCol.name, "*WPC")
			}
		} else {
			
			set tClassDef = ##class(%Dictionary.ClassDefinition).%New()
			set tClassDef.Name = pClassName
			set tClassDef.Super = "%Persistent"
			
			kill tCols
			for i = 1:1:tObject.columns.Count() {
				set tCol = tObject.columns.GetAt(i)
				set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
				set tPropDef.Name = $zstrip(tCol.name, "*WPC")
				set tPropDef.parent = tClassDef
				set tPropDef.Type = "%String"
				
				do:tCol.id="_pageUrl" tPropDef.Parameters.SetAt("300", "MAXLEN")
				do:'tCol.special tPropDef.Parameters.SetAt("", "MAXLEN")
					
				set tCols(tCol.id) = tPropDef.Name
			}
			
			set tSC = tClassDef.%Save()
			quit:$$$ISERR(tSC)
			set (tClassDef,tPropDef) = ""
		
			set tSC = $system.OBJ.Compile(pClassName, "crkdf")
			quit:$$$ISERR(tSC)
		}
		
		// load data
		set tRowCount = tObject.data.Count()
		for i = 1:1:tRowCount {
			set tInputRow = tObject.data.GetAt(i)
			set tOutputRow = $classmethod(pClassName, "%New")
			set tColID = ""
			for {
				set tColID = $order(tCols(tColID), 1, tPropName)
				quit:tColID=""
				
				set tPropValue = $property(tInputRow, tColID)
				if $isobject(tPropValue) {
					continue:'tPropValue.%IsA("%Library.ListOfDataTypes") 
					set tFullVal = ""
					for j = 1:1:tPropValue.Count() {
						set tFullVal = tFullVal_$s(j=1:"",1:$c(13,10))_tPropValue.GetAt(j)
					}
					set tPropValue = tFullVal
				}
				set $property(tOutputRow,tPropName) = tPropValue
			}
			set tSC = tOutputRow.%Save()
			quit:$$$ISERR(tSC)
			
			write:'(i#1000) !,"Processing row ",i," of ",tRowCount
		}
		quit:$$$ISERR(tSC)
		write !!,"Finished loading ",tRowCount," records",!
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}

