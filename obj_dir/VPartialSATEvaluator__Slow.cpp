// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VPartialSATEvaluator.h for the primary calling header

#include "VPartialSATEvaluator.h"
#include "VPartialSATEvaluator__Syms.h"

//==========

VL_CTOR_IMP(VPartialSATEvaluator) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = __VlSymsp = new VPartialSATEvaluator__Syms(this, name());
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VPartialSATEvaluator::__Vconfigure(VPartialSATEvaluator__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

VPartialSATEvaluator::~VPartialSATEvaluator() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void VPartialSATEvaluator::_eval_initial(VPartialSATEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VPartialSATEvaluator::_eval_initial\n"); );
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VPartialSATEvaluator::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VPartialSATEvaluator::final\n"); );
    // Variables
    VPartialSATEvaluator__Syms* __restrict vlSymsp = this->__VlSymsp;
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VPartialSATEvaluator::_eval_settle(VPartialSATEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VPartialSATEvaluator::_eval_settle\n"); );
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

void VPartialSATEvaluator::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VPartialSATEvaluator::_ctor_var_reset\n"); );
    // Body
    clause_mask = VL_RAND_RESET_I(5);
    unassign = VL_RAND_RESET_I(5);
    assignment = VL_RAND_RESET_I(5);
    clause_pole = VL_RAND_RESET_I(5);
    partial_sat = VL_RAND_RESET_I(1);
    { int __Vi0=0; for (; __Vi0<1; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
