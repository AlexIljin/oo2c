(* 	$Id: Hierarchical.Mod,v 1.5 2003/05/22 20:20:33 mva Exp $	 *)
MODULE URI:Scheme:Hierarchical;
(*  Implementation of the generic hierarchical URI.
    Copyright (C) 2000-2003  Michael van Acken

    This module is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public License
    as published by the Free Software Foundation; either version 2 of
    the License, or (at your option) any later version.

    This module is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with OOC. If not, write to the Free Software Foundation,
    59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*)


IMPORT
  TextRider, CC := CharClass, Object, Exception, ADT:StringBuffer,
  URI, Str := URI:String, URI:CharClass,
  UnparsedAuth := URI:Authority:Unparsed, UnparsedQuery := URI:Query:Unparsed;


TYPE
  Parameter* = POINTER TO ParameterDesc;
  ParameterDesc = RECORD
  (**A parameter of a path segment.  A path segment can have a list of
     several parameters.  *)
    next-: Parameter;
    string-: STRING;
    (**Parameter text.  Any escaped characters have been replaced by their
       character value.  *)
  END;

TYPE
  Segment* = POINTER TO SegmentDesc;
  SegmentDesc = RECORD
  (**A path segment of a hierarchical URI.  *)
    next-: Segment;
    string-: STRING;
    (**Segment text.  Any escaped characters have been replaced by their
       character value.  *)
    hasEscapes: BOOLEAN;
    (* TRUE iff a character in `string' was defined by an escape sequence *)
    paramList-: Parameter;
    (**List of parameters for this segment.  *)
  END;

TYPE
  Generic* = POINTER TO GenericDesc;
  GenericDesc* = RECORD
  (**This class implements the generic hierarchical URI.  *)
    (URI.HierarchicalURIDesc)
    pathList-: Segment;
    (**List of path segments of an URI.  A hierarchical URI may have an empty
       path.  In this case, this field is @code{NIL}.  *)
    absolutePath-: BOOLEAN;
    (**If @code{TRUE}, then @ofield{pathList} is an absolute path beginning
       at the root of the authority's name space.  Otherwise, the path is
       relative.  *)
  END;


(* Parameter
   ------------------------------------------------------------------------ *)
   
PROCEDURE InitParameter* (param: Parameter; string: STRING);
  BEGIN
    param. next := NIL;
    param. string := string
  END InitParameter;

PROCEDURE NewParameter* (string: STRING): Parameter;
  VAR
    param: Parameter;
  BEGIN
    NEW (param);
    InitParameter (param, string);
    RETURN param
  END NewParameter;

PROCEDURE (param: Parameter) Copy* (dest: Parameter);
  BEGIN
    dest. next := NIL;
    dest. string := param.string;
  END Copy;

PROCEDURE (param: Parameter) Clone* (): Parameter;
  VAR
    copy: Parameter;
  BEGIN
    NEW (copy);
    param. Copy (copy);
    RETURN copy
  END Clone;

PROCEDURE (param: Parameter) WriteXML* (w: TextRider.Writer);
  BEGIN
    w. WriteString (CC.eol+"<parameter>");
    w. WriteObject (param. string);
    w. WriteString ("</parameter>");
  END WriteXML;

PROCEDURE (param: Parameter) Append* (sb: StringBuffer.StringBuffer);
  BEGIN
    Str.AppendEscaped (param. string, CharClass.unreservedPChar, sb)
  END Append;


(* Path Segment
   ------------------------------------------------------------------------ *)
   
PROCEDURE InitSegment* (segm: Segment; string: STRING);
  BEGIN
    segm. next := NIL;
    segm. string := string;
    segm. paramList := NIL;
    segm. hasEscapes := FALSE
  END InitSegment;

PROCEDURE NewSegment* (string: STRING): Segment;
  VAR
    segm: Segment;
  BEGIN
    NEW (segm);
    InitSegment (segm, string);
    RETURN segm
  END NewSegment;

PROCEDURE (segm: Segment) AppendParameter* (param: Parameter);
  PROCEDURE Append (VAR list: Parameter);
    BEGIN
      IF (list = NIL) THEN
        list := param
      ELSE
        Append (list. next)
      END
    END Append;
  
  BEGIN
    param. next := NIL;
    Append (segm. paramList)
  END AppendParameter;

PROCEDURE (segm: Segment) Copy* (dest: Segment);
  VAR
    param: Parameter;
  BEGIN
    dest. next := segm. next;
    dest. string := segm. string;
    dest. paramList := NIL;
    param := segm. paramList;
    WHILE (param # NIL) DO
      dest. AppendParameter (param. Clone());
      param := param. next
    END
  END Copy;

PROCEDURE (segm: Segment) Clone* (): Segment;
  VAR
    copy: Segment;
  BEGIN
    NEW (copy);
    segm. Copy (copy);
    RETURN copy
  END Clone;

PROCEDURE (segm: Segment) WriteXML* (w: TextRider.Writer);
  VAR
    param: Parameter;
  BEGIN
    w. WriteString (CC.eol+"<segment>");
    w. WriteString (CC.eol+"<value>");
    w. WriteObject (segm. string);
    w. WriteString ("</value>");
    param := segm. paramList;
    WHILE (param # NIL) DO
      param. WriteXML (w);
      param := param. next
    END;
    w. WriteString (CC.eol+"</segment>");
  END WriteXML;

PROCEDURE (segm: Segment) Append* (sb: StringBuffer.StringBuffer);
  VAR
    param: Parameter;
  BEGIN
    Str.AppendEscaped (segm. string, CharClass.unreservedPChar, sb);
    param := segm. paramList;
    WHILE (param # NIL) DO
      sb.Append(";");
      param. Append (sb);
      param := param. next
    END;
  END Append;


(* Generic Hierarchical URI
   ------------------------------------------------------------------------ *)

PROCEDURE Init* (uri: Generic; schemeId: STRING;
                 authority: URI.Authority; query: URI.Query);
(**See @otype{Generic}.  *)
  BEGIN
    URI.InitHierarchicalURI (uri, schemeId, authority, query);
    uri. pathList := NIL;
    uri. absolutePath := TRUE
  END Init;

PROCEDURE New* (schemeId: STRING;
                authority: URI.Authority; query: URI.Query): Generic;
(**See @otype{Generic}.  *)
  VAR
    uri: Generic;
  BEGIN
    NEW (uri);
    Init (uri, schemeId, authority, query);
    RETURN uri
  END New;

PROCEDURE (uri: Generic) AppendSegment* (segm: Segment);
(**Adds the segment @oparam{segm} to the end of the list of path segments of
   @oparam{uri}.

   @precond
   @oparam{segm} has not been added to a URI previously.
   @end precond  *)
  PROCEDURE Append (VAR list: Segment);
    BEGIN
      IF (list = NIL) THEN
        list := segm
      ELSE
        Append (list. next)
      END
    END Append;
  
  BEGIN
    segm. next := NIL;
    Append (uri. pathList)
  END AppendSegment;

PROCEDURE (uri: Generic) RemoveSegment* (segm: Segment);
(**Removes the segment @oparam{segm} from the list of path segments of
   @oparam{uri}.

   @precond
   @oparam{segm} is part of @oparam{uri}
   @end precond  *)
  VAR
    ptr: Segment;
  BEGIN
    IF (uri. pathList = segm) THEN
      uri. pathList := segm. next
    ELSE
      ptr := uri. pathList;
      WHILE (ptr. next # segm) DO
        ptr := ptr. next
      END;
      ptr. next := segm. next
    END
  END RemoveSegment;
  
PROCEDURE (uri: Generic) StripSegments* (n: LONGINT);
(**Strips the last @oparam{n} segments from the hierarchical URI @oparam{uri}.

   @precond
   @oparam{n} >= 0
   @end precond  *)
  VAR
    dummy: LONGINT;
  
  PROCEDURE Strip (VAR list: Segment; n: LONGINT): LONGINT;
    VAR
      i: LONGINT;
    BEGIN
      IF (list = NIL) THEN
        RETURN n
      ELSE
        i := Strip (list. next, n);
        IF (i > 0) THEN
          list := NIL
        END;
        RETURN i-1
      END
    END Strip;
  
  BEGIN
    dummy := Strip (uri. pathList, n)
  END StripSegments;

PROCEDURE (uri: Generic) Clone* (): Generic;
  VAR
    copy: Generic;
  BEGIN
    NEW (copy);
    uri. Copy (copy);
    RETURN copy
  END Clone;

PROCEDURE (uri: Generic) Copy* (dest: URI.URI);
  VAR
    segm: Segment;
  BEGIN
    uri. Copy^ (dest);
    WITH dest: Generic DO
      dest. pathList := NIL;
      dest. absolutePath := uri. absolutePath;
      segm := uri. pathList;
      WHILE (segm # NIL) DO
        dest. AppendSegment (segm. Clone());
        segm := segm. next
      END
    END
  END Copy;

PROCEDURE (uri: Generic) ClearPath*;
  BEGIN
    uri. pathList := NIL;
    uri. absolutePath := TRUE
  END ClearPath;

PROCEDURE (uri: Generic) NewAuthority* (): URI.Authority;
  BEGIN
    RETURN UnparsedAuth.New("");
  END NewAuthority;

PROCEDURE (uri: Generic) NewQuery* (): URI.Query;
  BEGIN
    RETURN UnparsedQuery.New("");
  END NewQuery;

PROCEDURE (uri: Generic) ParsePath* (str: Object.CharsLatin1;
                                     absolute: BOOLEAN; offset: URI.Offset)
RAISES Exception.ParseError;
  VAR
    i, start: URI.Offset;
    segment, oldPathList: Segment;
    absToggle: BOOLEAN;
    substr: STRING;
  BEGIN
    oldPathList := uri. pathList;
    absToggle := absolute;
    uri. pathList := NIL;
    i := 0;
    LOOP
      start := i;
      WHILE (absToggle OR (str[i] # ":")) & CharClass.SkipPChar (str^, i) DO
      END;
      substr := Object.NewLatin1Region(str^, start, i);
      segment := NewSegment(Str.Unescape(substr));
      segment. hasEscapes := (substr.IndexOf("%", 0) >= 0);

      WHILE (str[i] = ";") DO
        INC (i);
        start := i;
        WHILE (absToggle OR (str[i] # ":")) & CharClass.SkipPChar (str^, i) DO
        END;
        segment. AppendParameter (NewParameter 
          (Str.Unescape(Object.NewLatin1Region(str^, start, i))))
      END;

      uri. AppendSegment (segment);
      absToggle := TRUE;
      IF (str[i] = "/") THEN
        INC (i)
      ELSE
        EXIT
      END
    END;
    IF (str[i] # 0X) THEN
      uri. pathList := oldPathList;
      RAISE(NEW(Exception.ParseError,
                "Illegal character in path component of the URI", i+offset));
    ELSE
      uri.absolutePath := absolute;
    END
  END ParsePath;

PROCEDURE (uri: Generic) ResolveRelative* (baseURI: URI.HierarchicalURI);
  VAR
    copy: URI.URI;
    ptr, next: Segment;
  
  PROCEDURE RemoveDot (VAR segm: Segment);
    BEGIN
      WHILE (segm # NIL) & ~segm. hasEscapes & segm.string.Equals(".") DO
        IF (segm. next = NIL) THEN
          segm.string := "";
        ELSE
          segm := segm. next
        END
      END;
      IF (segm # NIL) THEN
        RemoveDot (segm. next)
      END
    END RemoveDot;
  
  PROCEDURE RemoveDotDot (VAR segm: Segment): BOOLEAN;
    BEGIN
      IF (segm # NIL) THEN
        IF (segm # NIL) &
           (segm.hasEscapes OR ~segm.string.Equals("..")) &
           (segm.next # NIL) &
           segm.next.string.Equals("..") &
           ~segm.next.hasEscapes THEN
          IF (segm. next. next = NIL) THEN
            segm. string := "";
            segm. next := NIL
          ELSE
            segm := segm. next. next
          END;
          RETURN TRUE
        ELSE
          RETURN RemoveDotDot (segm. next)
        END
      ELSE
        RETURN FALSE
      END
    END RemoveDotDot;
  
  BEGIN
    uri. ResolveRelative^ (baseURI);
    IF ~uri. absolutePath THEN
      copy := baseURI. Clone();
      
      (* remove last segment from copy *)
      IF (copy(Generic). pathList # NIL) THEN
        IF (copy(Generic). pathList. next = NIL) THEN
          copy(Generic). pathList := NIL
        ELSE
          ptr := copy(Generic). pathList;
          WHILE (ptr. next. next # NIL) DO
            ptr := ptr. next
          END;
          ptr. next := NIL
        END
      END;
      
      (* append paths of uri to copy *)
      ptr := uri. pathList;
      WHILE (ptr # NIL) DO
        next := ptr. next;
        copy(Generic). AppendSegment (ptr);
        ptr := next
      END;
      uri. pathList := copy(Generic). pathList;
      
      RemoveDot (uri. pathList);
      WHILE RemoveDotDot (uri. pathList) DO END;
      uri. absolutePath := copy(Generic). absolutePath;
    END    
  END ResolveRelative;

PROCEDURE (uri: Generic) MakeRelative* (baseURI: URI.HierarchicalURI): Generic;
  VAR
    relURI: Generic;
    super: URI.URI;
    ptr, suffixBase, suffixRel: Segment;
  BEGIN
    IF (baseURI = NIL) THEN
      RETURN uri
    ELSE
      WITH baseURI: Generic DO
        super := uri. MakeRelative^ (baseURI);
        IF (super # uri) THEN
          relURI := super(Generic);

          (* if the base URI has an empty path, then the whole path of
             relURI is relative to this base URI; in this case, we are
             already done *)
          IF (baseURI. pathList # NIL) THEN
            IF (uri. pathList = NIL) THEN
              (* the URI is a relative reference to the base URI's root: add 
                 ".." for every segment within `baseURI' *)
              suffixBase := baseURI. pathList;
              suffixRel := NIL
            ELSE
              (* both URIs have non-empty paths: skip over common prefix
                 of both paths *)
              suffixBase := baseURI. pathList;
              suffixRel := uri. pathList;
              WHILE (suffixBase. next # NIL) & (suffixRel. next # NIL) &
                    suffixBase.string.Equals(suffixRel.string) DO
                suffixBase := suffixBase. next;
                suffixRel := suffixRel. next
              END
            END;

            (* erase path; then add the necessary ".." segments, followed by
               the suffix of the original URI *)
            relURI. ClearPath;
            ptr := suffixBase;
            WHILE (ptr. next # NIL) DO
              relURI. AppendSegment(NewSegment(".."));
              ptr := ptr. next
            END;
            ptr := suffixRel;
            WHILE (ptr # NIL) DO
              relURI. AppendSegment (ptr. Clone());
              ptr := ptr. next
            END
          END;
          relURI. absolutePath := FALSE;
          RETURN relURI
        ELSE
          RETURN uri
        END
      ELSE
        RETURN uri
      END
    END
  END MakeRelative;
  
PROCEDURE (uri: Generic) WriteXML* (w: TextRider.Writer);
  VAR
    segm: Segment;
    pathTag: ARRAY 32 OF CHAR;
  BEGIN
    w. WriteString (CC.eol+"<hierarchical-uri>");
    IF (uri. schemeId # NIL) THEN
      w. WriteString (CC.eol+"<scheme>");
      w. WriteObject (uri. schemeId);
      w. WriteString ("</scheme>");
    END;
    IF (uri. authority # NIL) THEN
      uri. authority. WriteXML (w)
    END;
    IF uri. absolutePath THEN
      pathTag := CC.eol+"<absolute-path>"
    ELSE
      pathTag := CC.eol+"<relative-path>"
    END;
    w. WriteString (pathTag);
    segm := uri. pathList;
    WHILE (segm # NIL) DO
      segm. WriteXML (w);
      segm := segm. next
    END;
    IF uri. absolutePath THEN
      pathTag := CC.eol+"</absolute-path>"
    ELSE
      pathTag := CC.eol+"</relative-path>"
    END;
    w. WriteString (pathTag);
    IF (uri. query # NIL) THEN
      uri. query. WriteXML (w)
    END;
    w. WriteString (CC.eol+"</hierarchical-uri>");
  END WriteXML;

PROCEDURE (uri: Generic) AppendPath* (sb: StringBuffer.StringBuffer);
  VAR
    segm: Segment;
  BEGIN
    IF (uri. pathList # NIL) THEN
      IF uri. absolutePath THEN
        sb.Append ("/");
      END;
      segm := uri. pathList;
      WHILE (segm # NIL) DO
        IF (segm # uri. pathList) THEN
          sb.Append("/");
        END;
        segm. Append (sb);
        segm := segm. next
      END
    END
  END AppendPath;

PROCEDURE (uri: Generic) ToString*(): Object.String8;
  VAR
    sb: StringBuffer.StringBuffer;
    str: STRING;
  BEGIN
    sb := StringBuffer.New("");
    uri. AppendScheme (sb);
    IF (uri. authority # NIL) THEN
      uri. authority. Append (sb);
    ELSIF (uri.schemeId # NIL) & uri.AuthorityMandatory() THEN
      sb.Append("//");
    END;
    uri. AppendPath (sb);
    IF (uri. query # NIL) THEN
      uri. query. Append (sb)
    END;
    str := sb.ToString();
    RETURN str(Object.String8);
  END ToString;

END URI:Scheme:Hierarchical.
