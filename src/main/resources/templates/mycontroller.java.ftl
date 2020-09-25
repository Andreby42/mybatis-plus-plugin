package ${package.Controller};

import java.util.List;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import javax.validation.Valid;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.web.bind.annotation.RequestMapping;
import ${package.Service}.${table.serviceName};
import ${package.Entity}.${table.entityName};
import com.cfyy.common.WrapMapper;
import com.cfyy.common.ServiceResultWrapper;
import org.apache.commons.lang3.StringUtils;
import static com.cfyy.common.Constant.ResponseCode.ILLEGAL_ARGUMENT_ERROR_CODE_;

<#if swagger2>
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.Api;
</#if>

<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>

/**
 * =====================================================================================
 *
 * @Created :   ${DATE} ${TIME}
 * @Compiler :  jdk 11
 * @Author :    ${author}
 * @Copyright : 长峰集团(http://www.cfyygf.com/)
 * @Decription : ${table.comment!} 控制器
 * =====================================================================================
 */
<#if swagger2>
@Api(tags = "${entity}管理")
</#if>
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
@RequestMapping("<#if package.ModuleName??>/${package.ModuleName}</#if>/<#if camelTableNameStyle??>${camelTableName}<#else>${table.entityPath}</#if>")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
  <#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
  <#else>
public class ${table.controllerName} {
  </#if>

    @Autowired
    private ${table.serviceName} ${cfg.camelTableName}Service;

<#if swagger2>    @ApiOperation(value = "查询${entity}")</#if>
    @GetMapping(value = "/page")
    public ServiceResultWrapper <IPage> get${entity}Page(Page<${entity}> page, ${entity} ${cfg.camelTableName}) {
        return WrapMapper.ok(${cfg.camelTableName}Service.page(page,Wrappers.query(${cfg.camelTableName})) );
    }

<#if swagger2>    @ApiOperation(value = "新增${entity}")</#if>
    @PostMapping(value = "/add")
    public ServiceResultWrapper create(@Valid @RequestBody ${entity} ${cfg.camelTableName}, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            String defaultMessage = fieldErrors.get(0).getDefaultMessage();
            return WrapMapper.error(ILLEGAL_ARGUMENT_ERROR_CODE_,StringUtils.isBlank(defaultMessage)?"系统错误":defaultMessage);
        }
        return WrapMapper.ok(${cfg.camelTableName}Service.save(${cfg.camelTableName}));
    }

<#if swagger2>    @ApiOperation(value = "修改${entity}")</#if>
    @PutMapping(value = "/update")
    public ServiceResultWrapper update(@Valid @RequestBody ${entity} ${cfg.camelTableName}, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            String defaultMessage = fieldErrors.get(0).getDefaultMessage();
            return WrapMapper.error(ILLEGAL_ARGUMENT_ERROR_CODE_,StringUtils.isBlank(defaultMessage)?"系统错误":defaultMessage);
         }
        return WrapMapper.ok(${cfg.camelTableName}Service.updateById(${cfg.camelTableName}));
    }

    <#list table.fields as field>
         <#if field.keyFlag>
    <#if swagger2>@ApiOperation(value = "删除${entity}")</#if>
    @DeleteMapping(value = "/delete/{${field.propertyName}}")
    public ServiceResultWrapper delete(@PathVariable ${field.propertyType} ${field.propertyName}) {
        return WrapMapper.ok(${cfg.camelTableName}Service.removeById(${field.propertyName}));
    }
         </#if>
    </#list>
}
</#if>
