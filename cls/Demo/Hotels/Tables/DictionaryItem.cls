Class Demo.Hotels.Tables.DictionaryItem Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Property DefaultLanguage As %String(MAXLEN = 150) [ ReadOnly ];

Property Dictionary As Dictionary [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {DictionaryId}}, SqlComputed ];

Property DictionaryId As %Integer(MINVAL = 1) [ ReadOnly ];

Property DictionaryItemId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Name As %String(MAXLEN = 1000) [ ReadOnly ];

Property Terms As %List [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $g(^ISC.IK.Mat.DictItemTerms(193,{DictionaryItemId}))}, SqlComputed ];

Property URI As %String(COLLATION = "EXACT", MAXLEN = 150) [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictItemURI On URI [ Type = key, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictToItem On DictionaryId;

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictionaryItemId On DictionaryItemId [ IdKey, PrimaryKey, Unique ];

Index DictItemExtent [ Extent, Type = bitmap ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>DictionaryId</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>URI</Value>
</Value>
<Value name="4">
<Value>DefaultLanguage</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.Mat.DictItemId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.Mat.DictItemId(1)</IdLocation>
<Index name="%DictItemURI">
<Location>^ISC.IK.Mat.DictItemURI(1)</Location>
</Index>
<Index name="%DictToItem">
<Location>^ISC.IK.Mat.DictToItem(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.MDI(1)</IndexLocation>
<StreamLocation>^Demo.Hotels6B2A.DictionaryItemS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

