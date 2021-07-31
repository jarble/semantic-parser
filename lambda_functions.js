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

function or(a){
	return function(b){
  	return function(c){
  		if(typeof(a) == 'function' && typeof(b) == 'function')
  		return a(c) || b(c);
  		else if(typeof(a) == 'boolean' && typeof(b) == 'boolean'){
		return a || b;	
		}
  	};
  };
}

function and(a){
	//this could be overloaded to work with sets as well as boolean functions
	return function(b){
  	return function(c){
		if(typeof(a) == 'function' && typeof(b) == 'function')
  		return a(c) && b(c);
  		else if(typeof(a) == 'boolean' && typeof(b) == 'boolean'){
		return a && b;	
		}
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
  if(a === 'function' || a === 'number' || a === 'boolean'){
  	return function(b){return typeof(b) === a};
  }
  else if(a === 'array'){
  	return function(b){
    	return Array.isArray(b);
    }
  }
}

var a1 = are(greater_than(0));
var a2 = or(is_a('function'))(is_a('number'));
console.log(a1.toString());

console.log(a1([1,2,3]));
console.log(a2(1));
