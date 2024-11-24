// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VUnitClauseEvaluator.h for the primary calling header

#include "VUnitClauseEvaluator.h"
#include "VUnitClauseEvaluator__Syms.h"

//==========

void VUnitClauseEvaluator::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VUnitClauseEvaluator::eval\n"); );
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("UnitClauseEvaluator.sv", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void VUnitClauseEvaluator::_eval_initial_loop(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("UnitClauseEvaluator.sv", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void VUnitClauseEvaluator::_combo__TOP__1(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_combo__TOP__1\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vtableidx1 = ((IData)(vlTOPp->clause_mask) 
                            & (IData)(vlTOPp->unassign));
    vlTOPp->UnitClauseEvaluator__DOT__encoded_position 
        = vlTOPp->__Vtable1_UnitClauseEvaluator__DOT__encoded_position
        [vlTOPp->__Vtableidx1];
    vlTOPp->UnitClauseEvaluator__DOT__valid_unit = 
        vlTOPp->__Vtable1_UnitClauseEvaluator__DOT__valid_unit
        [vlTOPp->__Vtableidx1];
    vlTOPp->unit_clause = vlTOPp->UnitClauseEvaluator__DOT__valid_unit;
    vlTOPp->implied_variable = vlTOPp->UnitClauseEvaluator__DOT__encoded_position;
    vlTOPp->new_assignment = (1U & (~ ((4U >= (IData)(vlTOPp->UnitClauseEvaluator__DOT__encoded_position)) 
                                       & ((IData)(vlTOPp->clause_pole) 
                                          >> (IData)(vlTOPp->UnitClauseEvaluator__DOT__encoded_position)))));
}

void VUnitClauseEvaluator::_eval(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_eval\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

VL_INLINE_OPT QData VUnitClauseEvaluator::_change_request(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_change_request\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData VUnitClauseEvaluator::_change_request_1(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_change_request_1\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void VUnitClauseEvaluator::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clause_mask & 0xe0U))) {
        Verilated::overWidthError("clause_mask");}
    if (VL_UNLIKELY((unassign & 0xe0U))) {
        Verilated::overWidthError("unassign");}
    if (VL_UNLIKELY((clause_pole & 0xe0U))) {
        Verilated::overWidthError("clause_pole");}
}
#endif  // VL_DEBUG
