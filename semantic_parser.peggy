

{
function less_than(a){
	return function(b){
  	return b < a;
  }
}

function greater_than(a){
  return function(b){
  	return b > a;
  }
}

function equal_to(a){
  return function(b){
  	return b === a;
  }
}

function or(a){
	//this could be overloaded to work with sets as well as boolean functions
    if(typeof(a) === 'boolean'){
    	return function(b){
        	return a || b;
        }
    }
    else
    return function(b){
  	return function(c){
		if(typeof(a) == 'function' && typeof(b) == 'function')
  		return a(c) || b(c);
  	};
  };
}

function and(a){
	//this could be overloaded to work with sets as well as boolean functions
    if(typeof(a) === 'boolean'){
    	return function(b){
        	return a && b;
        }
    }
    else
    return function(b){
  	return function(c){
		if(typeof(a) == 'function' && typeof(b) == 'function')
  		return a(c) && b(c);
  	};
  };
}

function identity(a){
	return function(b){return a;};
}

function not(a){
	return function(b){
    	return !a(b);
  };
}

function are(a){
	return function(b){
  	return b.every(a);
  }
}

function is_a(a){
  return function(b){
  if(a === 'function' || a === 'number' || a === 'boolean' || a === 'string'){
	return typeof(b) === a;
  }
  else if(a === 'array'){
    return Array.isArray(b);
  }
  else if(a === "even number"){
	return b%2 === 0;  
  }
  else if(a === "odd number"){
	return b%2 === 1;
  }
  else if(a === "positive number"){
	return b > 0;  
  }
  else if(a === "negative number"){
	return b < 0;
  }
  }
}

var a1 = are(greater_than(0));
var a2 = or(is_a('function'))(is_a('number'));
console.log(a1.toString());

console.log(a1([1,2,3]));
console.log(a2(1));

}

e4
  = head:e3 tail:(__ ("or" / "||") __ e3)* {
      return tail.reduce(function(result, element) {
        return and(result)(element[3]);
      }, head);
    }

e3
  = head:statement tail:(__ ("and" / "but" / "&&") __ statement)* {
      return tail.reduce(function(result, element) {
        return and(result)(element[3]);
      }, head);
    }


statement = a:Factor __ "is" __ b:e2 {return b(a);}


e2
  = head:e1 tail:(__ ("||" / "or") __ e1)* {
      let to_return = tail.reduce(function(result, element) {
        return or(result)(element[3]);
      }, head);
      return to_return;
    }

e1
  = head:verb_phrase tail:(__ ("&&" / "and") __ verb_phrase)* {
      let to_return = tail.reduce(function(result, element) {
        return and(result)(element[3]);
      }, head);
      return to_return;
    }

an = "an" / "a";

verb_phrase =
  an __ a:IDENTIFIER __ "number" {return is_a(a+" number")}
  /an __ a:Factor {return is_a(a)}
  / "less" __ "than" __ a:Factor {return less_than(a);}
  / ("greater" / "more") __ "than" __ a:Factor {return greater_than(a);}
  / "equal" __ "to" __ a:Factor {return equal_to(a);}
  / "not" __ a:verb_phrase {return not(a);}

Factor
  = "(" _ expr:verb_phrase _ ")" { return expr; }  
  / Integer
  / IDENTIFIER
  / STRING_LITERAL

Integer "integer"
  = _ [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t\n\r]*

IDENTIFIER = [a-zA-Z_][a-zA-Z0-9_]* {return text();}
STRING_LITERAL = '"' @$([^"\\] / "\\" .)* '"'

NUMBER = a:Integer b:NUMBER_ {let to_return =  a+"."+b; initial_value[to_return] = function(){return to_return;}; return to_return;}
NUMBER_ = "." a:Integer {return a;} / ("." / "") {return "";}

__
  = [ \t\n\r] [ \t\n\r]*
