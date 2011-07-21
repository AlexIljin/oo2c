static void* _c0;
static void* _c1;
static void* _c2;
static void* _c3;
static void* _c4;
#include <ADT/Object/Storage.oh>
#include <Strings.oh>
#define ADT_Object_Storage__pointerGap 4
static RT0__Module ADT_Object_Storage__object;
static RT0__Struct ADT_Object_Storage__string8;
static RT0__Struct ADT_Object_Storage__string16;

/* run-time meta data */
static RT0__ModuleDesc _mid;
RT0__StructDesc _td_ADT_Object_Storage__2078 = { (RT0__Struct[]){&_td_ADT_Object_Storage__2078}, (void*[]){}, NULL, &_mid, NULL, 12, 0, 0, RT0__strRecord };
RT0__StructDesc _td_ADT_Object_Storage__2069 = { (RT0__Struct[]){&_td_ADT_Object_Storage__2078}, NULL, NULL, &_mid, NULL, 12, 1, 0, RT0__strOpenArray };
RT0__StructDesc _td_ADT_Object_Storage__TypeRefMap = { (RT0__Struct[]){&_td_ADT_Object_Storage__2069}, NULL, NULL, &_mid, "TypeRefMap", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_ADT_Object_Storage__2179 = { (RT0__Struct[]){&_td_Object__Object}, NULL, NULL, &_mid, NULL, 4, 1, 0, RT0__strOpenArray };
RT0__StructDesc _td_ADT_Object_Storage__ObjectArray = { (RT0__Struct[]){&_td_ADT_Object_Storage__2179}, NULL, NULL, &_mid, "ObjectArray", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_ADT_Object_Storage__2237 = { (RT0__Struct[]){&_td_ADT_Object_Storage__2237}, (void*[]){}, NULL, &_mid, NULL, 12, 0, 0, RT0__strRecord };
RT0__StructDesc _td_ADT_Object_Storage__2228 = { (RT0__Struct[]){&_td_ADT_Object_Storage__2237}, NULL, NULL, &_mid, NULL, 12, 1, 0, RT0__strOpenArray };
RT0__StructDesc _td_ADT_Object_Storage__TypeArray = { (RT0__Struct[]){&_td_ADT_Object_Storage__2228}, NULL, NULL, &_mid, "TypeArray", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_ADT_Object_Storage__CharBuffer = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, "CharBuffer", 256, 256, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_ADT_Object_Storage__Reader = { (RT0__Struct[]){&_td_ADT_Object_Storage__ReaderDesc}, NULL, NULL, &_mid, "Reader", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_ADT_Object_Storage__ReaderDesc = { (RT0__Struct[]){&_td_IO_BinaryRider__ReaderDesc,&_td_ADT_Storable__ReaderDesc,&_td_ADT_Object_Storage__ReaderDesc}, (void*[]){(void*)IO_BinaryRider__ReaderDesc_SetPos,(void*)IO_BinaryRider__ReaderDesc_ReadBytes,(void*)IO_BinaryRider__ReaderDesc_ReadBytesOrdered,(void*)IO_BinaryRider__ReaderDesc_ReadBool,(void*)IO_BinaryRider__ReaderDesc_ReadChar,(void*)IO_BinaryRider__ReaderDesc_ReadLChar,(void*)IO_BinaryRider__ReaderDesc_ReadString,(void*)IO_BinaryRider__ReaderDesc_ReadLString,(void*)IO_BinaryRider__ReaderDesc_ReadSInt,(void*)IO_BinaryRider__ReaderDesc_ReadInt,(void*)IO_BinaryRider__ReaderDesc_ReadLInt,(void*)IO_BinaryRider__ReaderDesc_ReadNum,(void*)IO_BinaryRider__ReaderDesc_ReadReal,(void*)IO_BinaryRider__ReaderDesc_ReadLReal,(void*)IO_BinaryRider__ReaderDesc_ReadSet,(void*)IO_BinaryRider__ReaderDesc_ReadStr,(void*)IO_BinaryRider__ReaderDesc_SetByteOrder,(void*)ADT_Object_Storage__ReaderDesc_ReadObject,(void*)ADT_Object_Storage__ReaderDesc_Disconnect}, NULL, &_mid, "ReaderDesc", 280, 2, 0, RT0__strRecord };
RT0__StructDesc _td_ADT_Object_Storage__Writer = { (RT0__Struct[]){&_td_ADT_Object_Storage__WriterDesc}, NULL, NULL, &_mid, "Writer", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_ADT_Object_Storage__WriterDesc = { (RT0__Struct[]){&_td_IO_BinaryRider__WriterDesc,&_td_ADT_Storable__WriterDesc,&_td_ADT_Object_Storage__WriterDesc}, (void*[]){(void*)IO_BinaryRider__WriterDesc_SetPos,(void*)IO_BinaryRider__WriterDesc_WriteBytes,(void*)IO_BinaryRider__WriterDesc_WriteOrdered,(void*)IO_BinaryRider__WriterDesc_WriteChar,(void*)IO_BinaryRider__WriterDesc_WriteBool,(void*)IO_BinaryRider__WriterDesc_WriteLChar,(void*)IO_BinaryRider__WriterDesc_WriteString,(void*)IO_BinaryRider__WriterDesc_WriteLString,(void*)IO_BinaryRider__WriterDesc_WriteSInt,(void*)IO_BinaryRider__WriterDesc_WriteInt,(void*)IO_BinaryRider__WriterDesc_WriteLInt,(void*)IO_BinaryRider__WriterDesc_WriteNum,(void*)IO_BinaryRider__WriterDesc_WriteReal,(void*)IO_BinaryRider__WriterDesc_WriteLReal,(void*)IO_BinaryRider__WriterDesc_WriteSet,(void*)IO_BinaryRider__WriterDesc_WriteStr,(void*)IO_BinaryRider__WriterDesc_SetByteOrder,(void*)ADT_Object_Storage__WriterDesc_WriteObject,(void*)ADT_Object_Storage__WriterDesc_Disconnect}, NULL, &_mid, "WriterDesc", 280, 2, 0, RT0__strRecord };
static RT0__ModuleDesc _mid = { (OOC_CHAR8*)"ADT:Object:Storage", (RT0__Struct[]) { &_td_ADT_Object_Storage__TypeRefMap, &_td_ADT_Object_Storage__ObjectArray, &_td_ADT_Object_Storage__TypeArray, &_td_ADT_Object_Storage__CharBuffer, &_td_ADT_Object_Storage__Reader, &_td_ADT_Object_Storage__ReaderDesc, &_td_ADT_Object_Storage__Writer, &_td_ADT_Object_Storage__WriterDesc, NULL } };

extern void OOC_ADT_Object_Storage_init0() {
  RT0__RegisterModule(&_mid);
  OOC_ADT_Object_Storage_init();
}

/* --- */