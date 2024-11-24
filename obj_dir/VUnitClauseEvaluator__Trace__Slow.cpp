// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VUnitClauseEvaluator__Syms.h"


//======================

void VUnitClauseEvaluator::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void VUnitClauseEvaluator::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    VUnitClauseEvaluator::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void VUnitClauseEvaluator::traceInitTop(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void VUnitClauseEvaluator::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBus(c+1,"clause_mask", false,-1, 4,0);
        tracep->declBus(c+2,"unassign", false,-1, 4,0);
        tracep->declBus(c+3,"clause_pole", false,-1, 4,0);
        tracep->declBus(c+4,"implied_variable", false,-1, 2,0);
        tracep->declBit(c+5,"new_assignment", false,-1);
        tracep->declBit(c+6,"unit_clause", false,-1);
        tracep->declBus(c+1,"UnitClauseEvaluator clause_mask", false,-1, 4,0);
        tracep->declBus(c+2,"UnitClauseEvaluator unassign", false,-1, 4,0);
        tracep->declBus(c+3,"UnitClauseEvaluator clause_pole", false,-1, 4,0);
        tracep->declBus(c+4,"UnitClauseEvaluator implied_variable", false,-1, 2,0);
        tracep->declBit(c+5,"UnitClauseEvaluator new_assignment", false,-1);
        tracep->declBit(c+6,"UnitClauseEvaluator unit_clause", false,-1);
        tracep->declBus(c+7,"UnitClauseEvaluator valid_unassigned", false,-1, 4,0);
        tracep->declBus(c+8,"UnitClauseEvaluator encoded_position", false,-1, 2,0);
        tracep->declBit(c+9,"UnitClauseEvaluator valid_unit", false,-1);
    }
}

void VUnitClauseEvaluator::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void VUnitClauseEvaluator::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void VUnitClauseEvaluator::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullCData(oldp+1,(vlTOPp->clause_mask),5);
        tracep->fullCData(oldp+2,(vlTOPp->unassign),5);
        tracep->fullCData(oldp+3,(vlTOPp->clause_pole),5);
        tracep->fullCData(oldp+4,(vlTOPp->implied_variable),3);
        tracep->fullBit(oldp+5,(vlTOPp->new_assignment));
        tracep->fullBit(oldp+6,(vlTOPp->unit_clause));
        tracep->fullCData(oldp+7,(((IData)(vlTOPp->clause_mask) 
                                   & (IData)(vlTOPp->unassign))),5);
        tracep->fullCData(oldp+8,(vlTOPp->UnitClauseEvaluator__DOT__encoded_position),3);
        tracep->fullBit(oldp+9,(vlTOPp->UnitClauseEvaluator__DOT__valid_unit));
    }
}
