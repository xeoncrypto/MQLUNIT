/// @file   Assert.mqh
/// @author Copyright 2017, Eneset Group Trust
/// @brief  MQLUNIT_Assert class definition.

//-----------------------------------------------------------------------------
// Copyright 2017 Eneset Group Trust
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//-----------------------------------------------------------------------------

#property strict

#ifndef MQLUNIT_ASSERT_MQH
#define MQLUNIT_ASSERT_MQH

//-----------------------------------------------------------------------------

/// @brief A set of assert methods.
/// Due to the absence of exceptions in MQL the following convention is used
/// to specify an assertion error. Each assertion function will return a NULL
/// string in case of a success and the detailed failure description in case of
/// an assertion failure.
class MQLUNIT_Assert {
public:
    /// @brief Asserts that two objects are equal.
    /// Object are passed by reference. Pointers must be dereferenced to
    /// objects before passed to this method, therefore they must be checked
    /// for NULL before checking for equality.
    /// @param message : assertion description
    /// @param expected : expected object
    /// @param actual : actual object
    /// @return NULL on success or the failure description
    /// @see MQLUNIT_Assert::assertNull
    template <typename T>
    static string assertEquals(string message, T& expected, T& actual);
    
    /// @brief Asserts that two entities are equal.
    /// @param message : assertion description
    /// @param expected : expected value
    /// @param actual : actual value
    /// @return NULL on success or the failure description
    // We must define one of the assertEqual overloads in class
    // definition and one separately to avoid the compiler complaints
    // about not being able to overload a template function (which it does
    // just fine when we separate definition like this).
    template <typename T>
    static string assertEquals(string message, T expected, T actual) {
        if (expected != actual) {
            return StringConcatenate(
                message, ": expected:<", expected, "> but was:<", actual, ">"
            );
        }
        return NULL;
    };

    /// @brief Assert that two arrays are equal.
    /// Arrays are considered equal if they have the same size and their
    /// elements are equal in each position. Equality check for the elements
    /// will work with primitive types, strings, object references and pointers. 
    /// @param expected : expected array
    /// @param actual : actual array
    /// @param message : assertion description
    /// @return NULL on success or the failure description
    template <typename T>
    static string assertEquals(
        const string message, const T& expected[], const T& actual[]
    );

    /// @brief Asserts that two object references refer to the same object.
    /// Object are passed by reference. Pointers must be dereferenced to
    /// objects before passed to this method, therefore they must be checked
    /// for NULL before checking for equality.
    /// @param expected : expected object
    /// @param actual : actual object
    /// @param message : assertion description
    /// @return NULL on success or the failure description
    template <typename T>
    static string assertSame(string message, T& expected, T& actual);
  
    /// @brief Asserts that two object references do bot refer to the same
    /// object.
    /// Object are passed by reference. Pointers must be dereferenced to
    /// objects before passed to this method, therefore they must be checked
    /// for NULL before checking for equality.
    /// @param expected : expected object
    /// @param actual : actual object
    /// @param message : assertion description
    /// @return NULL on success or the failure description
    template <typename T>
    static string assertNotSame(string message, T& expected, T& actual);
  
    /// @brief Asserts that the entity is not NULL.
    /// Entity can be a variable of a primitive type, object reference or a
    /// pointer.
    /// @param entity : variable, object reference or a pointer to check
    /// @param message : assertion description
    /// @return NULL on success or the failure description
    template <typename T>
    static string assertNotNull(string message, T entity);
    
    /// @brief Asserts that the entity is NULL.
    /// Entity can be a variable of a primitive type, object reference or a
    /// pointer.
    /// @param entity : variable, object reference or a pointer to check
    /// @param message : assertion description
    /// @return NULL on success or the failure description
    template <typename T>
    static string assertNull(string message, T entity);
  
    /// @brief Asserts that the condition is true.
    /// @param message : assertion description
    /// @param condition : boolean expression to check
    /// @return NULL on success or the failure description
    static string assertTrue(string message, bool condition);
  
    /// @brief Asserts that the condition is false
    /// @param message : assertion description
    /// @param condition : boolean expression to check
    /// @return NULL on success or the failure description
    static string assertFalse(string message, bool condition);
  
    /// @brief Fail the test providing a genertc failure description.
    /// @return Generic failure description ("Assertion failed")
    static string fail() { return fail("Assertion failed"); };
    
    /// @brief Fail the test providing a specific failure description.
    /// @param message : failure description
    /// @return Failure description
    static string fail(string message) { return message; };

private:
    template <typename T>
    static string assertArrayElement(
        string message, T& expected, T& actual, uint i
    );

    // We must define one of the assertEqual overloads in class
    // definition and one separately to avoid the compiler complaints
    // about not being able to overload a template function (which it does
    // just fine when we separate definition like this).
    template <typename T>
    static string assertArrayElement(
        string message,T expected, T actual, uint i
    ) {
        if (expected != actual) {
            return StringConcatenate(
                message, ": expected array[", IntegerToString(i),"]:<",
                expected, "> but was:<", actual, ">"
            );
        }
        return NULL;
    };

};

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertEquals(
    string message, T& expected, T& actual
) {
    if (expected != actual) {
        return  StringConcatenate(
            message, ": expected:<", typename(expected), "#", &expected,
            "> but was:<", typename(actual), "#", &actual, ">"
        );
    }
    return NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertNotNull(string message, T entity) {
    return entity == NULL ? message : NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertNull(string message, T entity) {
    return entity != NULL ? message : NULL;
}

//-----------------------------------------------------------------------------

static string MQLUNIT_Assert::assertTrue(string message, bool condition) {
    return condition ? NULL : message;
}

//-----------------------------------------------------------------------------

static string MQLUNIT_Assert::assertFalse(string message, bool condition) {
    return condition ? message : NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertSame(
    string message, T& expected, T& actual
) {
  if (GetPointer(expected) != GetPointer(actual)) {
      return StringConcatenate(
          message, ": expected same:<", &expected , "> was not:<", &actual, ">"
      );
  }
  return NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertNotSame(
    string message, T& expected, T& actual
) {
    if (GetPointer(expected) == GetPointer(actual)) {
        return StringConcatenate(message, ": expected not same");
    }
  return NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertEquals(
    string   message, const T& expected[], const T& actual[]
) {
  const int expectedSize = ArraySize(expected);
  const int actualSize   = ArraySize(actual);

  if (expectedSize != actualSize) {
      return StringConcatenate(
          message , ": expected array size is:<",
          IntegerToString(expectedSize), "> but was:<",
          IntegerToString(actualSize), ">"
      );
  }

  for (int i = 0; i < actualSize; i++) {
      if (expected[i] != actual[i]) {
          return assertArrayElement(message, expected[i], actual[i], i);
      }
  }
  return NULL;
}

//-----------------------------------------------------------------------------

template <typename T>
static string MQLUNIT_Assert::assertArrayElement(
    string message, T& expected, T& actual, uint i
) {
  if (expected != actual) {
      return StringConcatenate(
          message, ": expected array[", IntegerToString(i), "]:<",
          typename(expected), "#", &expected, "> but was:<", typename(actual),
          "#", &actual, ">"
      );
  }
  return NULL;
}

//-----------------------------------------------------------------------------

#endif