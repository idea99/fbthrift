#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#
from libcpp.memory cimport shared_ptr, make_shared, unique_ptr, make_unique
from libcpp.string cimport string
from libcpp cimport bool as cbool
from cpython cimport bool as pbool
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t
from libcpp.vector cimport vector as vector
from libcpp.set cimport set as cset
from libcpp.map cimport map as cmap
from cython.operator cimport dereference as deref, typeid
from cpython.ref cimport PyObject
from thrift.py3.client cimport cRequestChannel_ptr, makeClientWrapper
from thrift.py3.exceptions cimport try_make_shared_exception, raise_py_exception
from folly cimport cFollyTry, cFollyUnit, c_unit
from libcpp.typeinfo cimport type_info
import thrift.py3.types
cimport thrift.py3.types
import thrift.py3.client
cimport thrift.py3.client
from folly.futures cimport bridgeFutureWith
from folly.executor cimport get_executor
cimport cython

import asyncio
import sys
import traceback

cimport my.namespacing.extend.test.extend.types
import my.namespacing.extend.test.extend.types
cimport hsmodule.types
import hsmodule.types
cimport hsmodule.clients
import hsmodule.clients

from my.namespacing.extend.test.extend.clients_wrapper cimport cExtendTestServiceAsyncClient, cExtendTestServiceClientWrapper
from hsmodule.clients_wrapper cimport cHsTestServiceClientWrapper


cdef void ExtendTestService_check_callback(
    cFollyTry[cbool]&& result,
    PyObject* future
):
    cdef object pyfuture = <object> future
    if result.hasException():
        try:
            raise_py_exception(result.exception())
        except Exception as ex:
            pyfuture.set_exception(ex)
    else:
        pyfuture.set_result(<bint>result.value())


cdef class ExtendTestService(hsmodule.clients.HsTestService):

    def __cinit__(ExtendTestService self):
        loop = asyncio.get_event_loop()
        self._deferred_headers = {}
        self._connect_future = loop.create_future()
        self._executor = get_executor()

    cdef const type_info* _typeid(ExtendTestService self):
        return &typeid(cExtendTestServiceAsyncClient)

    @staticmethod
    cdef _extend_ExtendTestService_set_client(ExtendTestService inst, shared_ptr[cExtendTestServiceClientWrapper] c_obj):
        """So the class hierarchy talks to the correct pointer type"""
        inst._extend_ExtendTestService_client = c_obj
        hsmodule.clients.HsTestService._hsmodule_HsTestService_set_client(inst, <shared_ptr[cHsTestServiceClientWrapper]>c_obj)

    cdef _extend_ExtendTestService_reset_client(ExtendTestService self):
        """So the class hierarchy resets the shared pointer up the chain"""
        self._extend_ExtendTestService_client.reset()
        hsmodule.clients.HsTestService._hsmodule_HsTestService_reset_client(self)

    def __dealloc__(ExtendTestService self):
        if self._cRequestChannel or self._extend_ExtendTestService_client:
            print('client was not cleaned up, use the context manager', file=sys.stderr)

    async def __aenter__(ExtendTestService self):
        await self._connect_future
        if self._cRequestChannel:
            ExtendTestService._extend_ExtendTestService_set_client(
                self,
                makeClientWrapper[cExtendTestServiceAsyncClient, cExtendTestServiceClientWrapper](
                    self._cRequestChannel
                ),
            )
            self._cRequestChannel.reset()
        else:
            raise asyncio.InvalidStateError('Client context has been used already')
        for key, value in self._deferred_headers.items():
            self.set_persistent_header(key, value)
        self._deferred_headers = None
        return self

    async def __aexit__(ExtendTestService self, *exc):
        self._check_connect_future()
        loop = asyncio.get_event_loop()
        future = loop.create_future()
        bridgeFutureWith[cFollyUnit](
            self._executor,
            deref(self._extend_ExtendTestService_client).disconnect(),
            closed_ExtendTestService_py3_client_callback,
            <PyObject *>future
        )
        # To break any future usage of this client
        badfuture = loop.create_future()
        badfuture.set_exception(asyncio.InvalidStateError('Client Out of Context'))
        badfuture.exception()
        self._connect_future = badfuture
        await future
        self._extend_ExtendTestService_reset_client()

    def set_persistent_header(ExtendTestService self, str key, str value):
        if not self._extend_ExtendTestService_client:
            self._deferred_headers[key] = value
            return

        cdef string ckey = <bytes> key.encode('utf-8')
        cdef string cvalue = <bytes> value.encode('utf-8')
        deref(self._extend_ExtendTestService_client).setPersistentHeader(ckey, cvalue)

    @cython.always_allow_keywords(True)
    async def check(
            ExtendTestService self,
            hsmodule.types.HsFoo struct1):
        if struct1 is None:
            raise TypeError('struct1 can not be None')
        self._check_connect_future()
        __loop = asyncio.get_event_loop()
        __future = __loop.create_future()
        bridgeFutureWith[cbool](
            self._executor,
            deref(self._extend_ExtendTestService_client).check(
                deref((<hsmodule.types.HsFoo>struct1)._cpp_obj),
            ),
            ExtendTestService_check_callback,
            <PyObject *> __future
        )
        return await __future



cdef void closed_ExtendTestService_py3_client_callback(
    cFollyTry[cFollyUnit]&& result,
    PyObject* fut,
):
    cdef object pyfuture = <object> fut
    pyfuture.set_result(None)
