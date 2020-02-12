package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.tika.Tika;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.ProductsAttachVO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	private String getFolder() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		
		log.info("check Image Type");
		
		try {
			
			log.info("check Image Type Function " + file);
			
			//String contentType = Files.probeContentType(file.toPath());
			
			String contentType = new Tika().detect(file);
			
			log.info(contentType);
			
			return contentType.startsWith("image");
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	@PostMapping(value = "/uploadAjaxAction", 
			produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<ProductsAttachVO>> 
		uploadAjaxPost(MultipartFile[] uploadFile) {
		
		log.info("update ajax post");
		
		List<ProductsAttachVO> attachList = new ArrayList<>();
		
		String uploadFolder = "/usr/local/apache-tomcat-9.0.29/webapps/upload/";
		// "C:\\upload"
		// "/usr/local/apache-tomcat-9.0.29/webapps/upload"
		
		String uploadFolderPath = getFolder();
		// 폴더 생성
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("upload path: " + uploadPath);
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		// 날짜(yyyy/mm/dd)를 이름에 포함한 폴더 생성
		
		for(MultipartFile multipartFile : uploadFile) {
			
			log.info("--------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename());
			log.info("Upload File Size: " + multipartFile.getSize());
			
			ProductsAttachVO attachVO = new ProductsAttachVO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			uploadFileName = uploadFileName
					.substring(uploadFileName.lastIndexOf("\\") + 1);
			
			attachVO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				
				log.info(saveFile);
				
				multipartFile.transferTo(saveFile);
				
				attachVO.setUuid(uuid.toString());
				attachVO.setUploadPath(uploadFolderPath);
				
				// 파일 타입 체크
				if(checkImageType(saveFile)) {
					
					log.info("check Image Type " + saveFile);
					
					attachVO.setImageType(true);
					
					FileOutputStream thumbnail = 
							new FileOutputStream(new File(uploadPath, "s_" 
									+ uploadFileName));
					
					FileOutputStream bigThumbnail = 
							new FileOutputStream(new File(uploadPath, "bs_" 
					+ uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), 
							thumbnail, 100, 100);
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), 
							bigThumbnail, 266, 381);
					
					thumbnail.close();
					bigThumbnail.close();
				}
				
				attachList.add(attachVO);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		return new ResponseEntity<>(attachList, HttpStatus.OK);
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		
		log.info("fileName : " + fileName);
		
		File file = new File("/usr/local/apache-tomcat-9.0.29/webapps/upload/" + fileName);
		// "c:\\upload\\"
		// "/usr/local/apache-tomcat-9.0.29/webapps/upload"
		
		log.info("file : " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), 
					header, HttpStatus.OK);
		} catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value = "/download", 
			produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		
		Resource resource = new FileSystemResource("/usr/local/apache-tomcat-9.0.29/webapps/upload/" + fileName);
		// "c:\\upload\\"
		// "/usr/local/apache-tomcat-9.0.29/webapps/upload"
		
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		log.info(resourceName);
		// UUID 삭제
		String resourceOriginalName = 
				resourceName.substring(resourceName.indexOf("_") + 1);
		log.info(resourceOriginalName);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			
			String downloadName = null;
			
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName =
					URLEncoder.encode(resourceOriginalName, "UTF-8")
						.replaceAll("\\+", " ");
			} else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = 
					URLEncoder.encode(resourceOriginalName, "UTF-8");
			} else {
				log.info("Chrome browser");
				downloadName = 
					new String(resourceOriginalName.getBytes("UTF-8"), 
							"ISO-8859-1");
			}
		
			log.info("downloadName : " + downloadName);
			
			headers.add("Content-Disposition", 
					"attachment; fileName=" + downloadName);
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
				
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile : " + fileName);
		
		File file;
		
		try {
			
			file = new File("/usr/local/apache-tomcat-9.0.29/webapps/upload/" + URLDecoder.decode(fileName, "UTF-8"));
			// "c:\\upload\\"
			// "/usr/local/apache-tomcat-9.0.29/webapps/upload"
			
			file.delete();
			
			if(type.equals("image")) {
				// 썸네일
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				// 뷰에서 받아온 파일 이름을 사용
				log.info("largeFileName : " + largeFileName);

				file = new File(largeFileName);
				
				file.delete();
				
				// 빅썸네일 삭제가 안됨
				String bigFileName = file.getAbsolutePath().replace("bs_", "");
				// 뷰에서 받아온 파일 이름을 이용해서 bs가 붙은 파일 이름을 만들어야 함
				log.info("bigFileName : " + bigFileName);
				
				file = new File(bigFileName);
				
				file.delete();

			}
		} catch(UnsupportedEncodingException e) {
			
			e.printStackTrace();
			
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	
	
}
