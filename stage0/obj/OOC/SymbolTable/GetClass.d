#include <OOC/SymbolTable/GetClass.oh>
#include <Strings.oh>

/* run-time meta data */
static RT0__ModuleDesc _mid;
static RT0__ModuleDesc _mid = { (OOC_CHAR8*)"OOC:SymbolTable:GetClass", (RT0__Struct[]) { NULL } };

extern void OOC_OOC_SymbolTable_GetClass_init0() {
  RT0__RegisterModule(&_mid);
  OOC_OOC_SymbolTable_GetClass_init();
}

/* --- */