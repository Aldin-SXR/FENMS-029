// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Strings.sol";

contract ElectiveCoursesIBU {
   // Course mappings
   mapping(uint => uint) private courseCapacity;

   mapping(uint =>  mapping(address => bool)) private courseStudents;

   string[] private courses = [
       "Advanced Web3 Concepts", // 0
       "Introduction to DevOps", // 1
       "Secure Software System Development", // 2
       "Software Engineering", // 3
       "Introduction to Machine Learning", // 4
       "Data Mining", // 5
       "Introduction to Mobile and Wireless Networking", // 6
       "Advanced Mobile Engineering" // 7
   ];

   uint[] private maxCap = [
       30, 30, 80, 80, 30, 30, 20, 20
   ];

   function getCourse(uint id) public view returns (string memory) {
       return courses[id];
   }

   function getCourseWithCapacity(uint id) public view returns (string memory) {
       return string.concat(courses[id], " (", Strings.toString(courseCapacity[id]), "/", Strings.toString(maxCap[id]), ")");
   }

   function registerCourses(address student, uint[] calldata courseIds) external {
       for (uint i = 0; i < courseIds.length; i++) {
           // Check max capacity for a course
           require(courseIds[i] >= 0 && courseIds[i] <= 6, "You are choosing a non-existing course!");
           require(courseCapacity[courseIds[i]] < maxCap[courseIds[i]], string.concat("Course ", getCourse(courseIds[i]), " filled up!"));
           require(courseStudents[courseIds[i]][student] != true, string.concat("You already chose ", getCourse(courseIds[i]), "!"));
          
           courseCapacity[courseIds[i]]++;
           courseStudents[courseIds[i]][student] = true;
       }
   }

   function unregisterCourses(address student, uint[] calldata courseIds) external {
       for (uint i = 0; i < courseIds.length; i++) {
           // Check max capacity for a course
           require(courseIds[i] >= 0 && courseIds[i] <= 6, "You are selecting a non-existing course!");
           require(courseStudents[courseIds[i]][student] == true, string.concat("You are not enrolled to ", getCourse(courseIds[i]), "!"));
          
           courseCapacity[courseIds[i]]--;
           courseStudents[courseIds[i]][student] = false;
       }
   }

   function getStudentCourses(address student) external view returns (string[] memory) {
       uint size = 0;
       for (uint i = 0; i < 7; i++) {
           if (courseStudents[i][student] == true) {
               size++;
           }
       }
      
       string[] memory sc = new string[](size);
       uint count = 0;
       for (uint i = 0; i < 7; i++) {
           if (courseStudents[i][student] == true) {
               sc[count] = getCourse(i);
               count++;
           }
       }
       return sc;
   }
}
