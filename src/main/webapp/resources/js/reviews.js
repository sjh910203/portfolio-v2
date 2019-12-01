console.log("Reply Module ready");

var reviewsService = (function() {
	
	// 댓글 추가
	function add(reviews, callback, error) {
		
		console.log("add reviews");
		
		$.ajax({
			type: 'post',
			url: '/reviews/new',
			data: JSON.stringify(reviews),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	// /add function
	
	// 댓글 리스트 출력
	function getList(param, callback, error) {
		
		var productsNo = param.productsNo;
		var page = param.page || 1;
		
		$.getJSON("/reviews/pages/" + productsNo + "/" + page +".json",
			function(data) {
				if(callback) {
					callback(data.reviewsCnt, data.list);
				}
			}		
		).fail(function(xhr, status, err) {
				if(error) {
					error();
				}
			});
	}
	// /getList function
	
	// 댓글 삭제
	function remove(reviewsNo, reviewer, callback, error) {
		$.ajax({
			type: 'delete',
			url: '/reviews/' + reviewsNo,
			data: JSON.stringify({reviewsNo:reviewsNo, reviewer:reviewer}),
			contentType: "application/json; charset=utf-8",
			success: function(deleteResult, status, xhr) {
				if(callback) {
					callback('상품평 삭제 완료');
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	// /remove function
	
	// 댓글 수정
	function update(reviews, callback, error) {
		
		console.log("update reviews : " + reviews.reviewsNo);
		
		$.ajax({
			type: 'put',
			url: '/reviews/' + reviews.reviewsNo,
			data: JSON.stringify(reviews),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) {
					callback('상품평 수정 완료');
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	// /update function
	
	// 댓글 조회
	function get(reviewsNo, callback, error) {
		
		$.get("/reviews/" + reviewsNo + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}
	// /get
	
	// 댓글 시간
	function displayTime(timeValue) {
		
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap < (1000 * 60 * 60 * 24)) {
			
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : 0) + mi, ':', (ss > 9 ? '' : 0) + ss].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
		}
	}
	// /displayTime
	
	return {
		add : add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};
	
})();
// /reviewsService