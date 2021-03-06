Class Demo.Hotels.Tables.Source Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property Author As %String [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.MetadataAPI).GetValueById({DomainId},2,{SourceId})}, SqlComputed ];

Property AuthorIsTruncated As %Boolean [ Calculated, Internal, ReadOnly, SqlComputeCode = {set {*} = ($length({Author})>150)}, SqlComputed ];

Property CrcOccurrenceCount As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),6)}, SqlComputed ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property EntityOccurrenceCount As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.EntityAPI).GetOccurrenceCountBySource(1, {SourceId})}, SqlComputed ];

Property ExternalId As %String(MAXLEN = 1000) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.SourceAPI).GetExternalId(1, {SourceId})}, SqlComputed ];

Property FirstCrcOccurrenceId As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),5)+1}, SqlComputed ];

Property FirstPartId As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),3)+1}, SqlComputed ];

Property FirstPathId As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),7)+1}, SqlComputed ];

Property FirstSentenceId As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),1)+1}, SqlComputed ];

Property FullText As %String(MAXLEN = "") [ Calculated, ReadOnly, SqlComputeCode = {new tTxt,tFrom,tTo,tSentId,tOut,tMore  s tTxt = "", tFrom=$lg($g(^ISC.IK.SrcDetails(1,{SourceId})),1)+1, tTo=tFrom-1+$lg($g(^({SourceId})),2) for tSentId = tFrom:1:tTo { k tOut  set tMore = ##class(%iKnow.Queries.SentenceAPI).GetValue(1,tSentId,.tOut)  set tOut="" for { set tOut = $order(tOut(tOut),1,tMore) q:tOut=""  set tTxt = tTxt _ tMore _ " " } }  set {*} = $e(tTxt,1,*-1)}, SqlComputed ];

Property GroupId As %Integer(MINVAL = 0) [ ReadOnly ];

Property GroupName As %String(MAXLEN = 150) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $g(^ISC.IK.Ext.Group(1,{ListerId},{GroupId}))}, SqlComputed ];

Property ListerClass As %String(MAXLEN = 150) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $g(^ISC.IK.Sys.ListerD({ListerId}))}, SqlComputed ];

Property ListerId As %Integer(MINVAL = 0) [ ReadOnly ];

Property LocalReference As %String(COLLATION = "EXACT", MAXLEN = 150) [ ReadOnly ];

Property PartCount As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),4)}, SqlComputed ];

Property PathCount As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),8)}, SqlComputed ];

Property Ref As Demo.Hotels.Review [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {LocalReference}}, SqlComputed ];

Property SentenceCount As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.SrcDetails(1,{SourceId})),2)}, SqlComputed ];

Property SourceId As %Integer(MINVAL = 1) [ ReadOnly ];

Property StayMonth As %String [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.MetadataAPI).GetValueById({DomainId},4,{SourceId})}, SqlComputed ];

Property StayMonthIsTruncated As %Boolean [ Calculated, Internal, ReadOnly, SqlComputeCode = {set {*} = ($length({StayMonth})>150)}, SqlComputed ];

Property StayType As %String [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.MetadataAPI).GetValueById({DomainId},3,{SourceId})}, SqlComputed ];

Property StayTypeIsTruncated As %Boolean [ Calculated, Internal, ReadOnly, SqlComputeCode = {set {*} = ($length({StayType})>150)}, SqlComputed ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %ExtIdComp On (ListerId, GroupId, LocalReference) [ Type = key, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %MdtAuthor On (Author, AuthorIsTruncated);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %MdtStayMonth On (StayMonth, StayMonthIsTruncated);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %MdtStayType On (StayType, StayTypeIsTruncated);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %SourceId On SourceId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %SrcExists [ Extent, Type = bitmap ];

ClassMethod SyncCustomizations(pAutoPurge As %Boolean = 1, pStartSrcId As %Integer = "", pEndSrcId As %Integer = "") As %Status [ SqlName = SyncCustomizations, SqlProc ]
{
	quit ##class(%iKnow.Tables.Utils).SyncCustomizations(..#DOMAINID,"Demo.Hotels.Tables",pAutoPurge,pStartSrcId,pEndSrcId)
}

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>ListerId</Value>
</Value>
<Value name="2">
<Value>GroupId</Value>
</Value>
<Value name="3">
<Value>LocalReference</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.SrcId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.SrcId(1)</IdLocation>
<Index name="%ExtIdComp">
<Location>^ISC.IK.Ext.LocalRef(1)</Location>
</Index>
<Index name="%MdtAuthor">
<Location>^ISC.IK.Mdt.ValueToSrc(1,2)</Location>
</Index>
<Index name="%MdtStayMonth">
<Location>^ISC.IK.Mdt.ValueToSrc(1,4)</Location>
</Index>
<Index name="%MdtStayType">
<Location>^ISC.IK.Mdt.ValueToSrc(1,3)</Location>
</Index>
<Index name="%SrcExists">
<Location>^ISC.IK.SrcExistsBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.Src(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.SourceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

