import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.service.ServiceUtil
import org.apache.ofbiz.testtools.GroovyScriptTestCase

class OrderTests extends GroovyScriptTestCase {
    void testAddRequirementTask() {
        Map serviceCtx = [:]
        serviceCtx.requirementId = "1000"
        serviceCtx.workEffortId = "9000"
        serviceCtx.userLogin = EntityQuery.use(delegator).from("UserLogin").where("userLoginId", "system").cache().queryOne()
        Map serviceResult = dispatcher.runSync("addRequirementTask", serviceCtx)
        assert ServiceUtil.isSuccess(serviceResult)
    }
    void testCreateReturnAdjustment() {
        Map serviceCtx = [:]
        serviceCtx.amount = '2.0000'
        serviceCtx.returnId = '1009'
        serviceCtx.userLogin = EntityQuery.use(delegator).from('UserLogin').where('userLoginId', 'system').cache().queryOne()
        Map serviceResult = dispatcher.runSync('createReturnAdjustment', serviceCtx)
        assert ServiceUtil.isSuccess(serviceResult)
        assert serviceResult.returnAdjustmentId != null
    }
}